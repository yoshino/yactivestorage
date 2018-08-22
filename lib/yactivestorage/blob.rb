require "yactivestorage/site"
require "yactivestorage/filename"

# Schema: id, key, filename, content_type, metadata, byte_size, checksum, created_at
class Yactivestorage::Blob < ActiveRecord::Base
  self.table_name = "yactivestorage_blobs"

  store :metadata, coder: JSON
  has_secure_token :key

  class_attribute :site # disk, gcs, mirror, s3.....

  class << self

    def build_after_upload(io:, filename:, content_type: nil, metadata: nil)
      new.tap do |blob|
        blob.filename = filename
        blob.content_type = content_type

        blob.upload io
      end
    end

    def create_after_upload!(io:, filename:, content_type: nil, metadata: nil)
      build_after_upload(io: io, filename: filename, content_type: content_type, metadata: metadata).tap(&:save!)
    end
  end

  # We can't wait until thre record is first saved to have a key for it
  def key
    self[:key] ||= self.class.generate_unique_secure_token
  end

  def filename
    Yactivestorage::Filename.new(self[:filename])
  end

  def url(expires_in: 5.minutes, disposition: :inline)
    site.url key, expires_in: expires_in, disposition: disposition, filename: filename
  end

  def upload(io)
    site.upload key, io

    self.checksum = site.checksum(key)
    self.byte_size = site.byte_size(key)
  end

  def download
    site.download key
  end

  def delete
    site.delete key
  end

  def purge
    delete
    destroy
  end

  def purge_later
    Yactivestorage::PurgeJob.perform_later(self)
  end
end
