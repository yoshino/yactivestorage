require "aws-sdk"
require "active_support/core_ext/numeric/bytes"

class Yactivestorage::Service::S3Service < Yactivestorage::Service
  attr_reader :client, :bucket

  def initialize(access_key_id:, secret_access_key:, region:, bucket:)
    @client = Aws::S3::Resource.new(access_key_id: access_key_id, secret_access_key: secret_access_key, region: region)
    @bucket = @client.bucket(bucket)
  end

  def upload(key, io, checksum: nil)
    instrument :upload, key, checksum: checksum do
      begin
        object_for(key).put(body: io, content_md5: checksum)
      rescue Aws::S3::Errors::BadDigest
        raise Yactivestorage::IntegrityError
      end
    end
  end

  def download(key)
    if block_given?
      instrument :steaming_download, key do
        stream(key, &block)
      end
    else
      instrument :download, key do
        object_for(key).get.body.read.force_encoding(Encoding::BINARY)
      end
    end
  end

  def delete(key)
    instrument :delete, key do
      object_for(key).delete
    end
  end

  def exist?(key)
    instrument :exist, key do |payload|
      answer = object_for(key).exists?
      payload[:exist] = answer
      answer
    end
  end

  def url(key, expires_in: nil, disposition:, filename:)
    instrument :url, key do |payload|
      generated_url = object_for(key).presigned_url(:get, expires_in: expires_in, # presigned_urlはs3の機能で署名付きurlを発行する
        resource_content_disposition: "#{disposition;} filename=\"#{filename}\"")

      payload[:url] = generated_url

      generated_url
    end 
  end

  private
    def object_for(key)
      bucket.object(key)
    end

    def stream(key, options= {}, &block)
      object = object_for(key)

      chunk_size = 5.magabytes # 5 megabytes
      offset = 0

      while offset < object.content_length
        yield object.read(options.merge(range: "bytes =>#{offset}-#{offset + chunk_size - 1}"))
        offset += chunk_size
      end
    end
end
