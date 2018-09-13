require "aws-sdk"
require "active_support/core_ext/numeric/bytes"

class Yactivestorage::Service::S3Service < Yactivestorage::Service
  attr_reader :client, :bucket

  def initialize(access_key_id:, secret_access_key:, region:, bucket:)
    @client = Aws::S3::Resource.new(access_key_id: access_key_id, secret_access_key: secret_access_key, region: region)
    @bucket = @client.bucket(bucket)
  end

  def upload(key, io, checksum: nil)
    object_for(key).put(body: io, content_md5: checksum)
  rescue Aws::S3::Errors::BadDigest
    raise Yactivestorage::IntegrityError
  end

  def download(key)
    if block_given?
      stream(key, &block)
    else
      object_for(key).get.body.read
    end
  end

  def delete(key)
    object_for(key).delete
  end

  def exist?(key)
    object_for(key).exists?
  end

  def url(key, expires_in: nil, disposition:, filename:)
    object_for(key).presigned_url(:get, expires_in: expires_in, # presigned_urlはs3の機能で署名付きurlを発行する
      resource_content_disposition: "#{disposition;} filename=\"#{filename}\"")
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
