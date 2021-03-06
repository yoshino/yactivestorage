require "active_storage/service"
require "active_storage/filename"
require "active_storage/purge_job"
require "active_storage/variant"
require "active_storage/variation"

# Schema: id, key, filename, content_type, metadata, byte_size, checksum, created_at
class ActiveStorage::Blob < ActiveRecord::Base
  self.table_name = "active_storage_blobs"

  has_secure_token :key
  store :metadata, coder: JSON

  class_attribute :service

  class << self
    def find_signed(id)
      find ActiveStorage.verifier.verify(id, purpose: :blob_id)
    end

    def build_after_upload(io:, filename:, content_type: nil, metadata: nil)
      new.tap do |blob|
        blob.filename     = filename
        blob.content_type = content_type
        blob.metadata     = metadata

        blob.upload io
      end
    end

    def create_after_upload!(io:, filename:, content_type: nil, metadata: nil)
      build_after_upload(io: io, filename: filename, content_type: content_type, metadata: metadata).tap(&:save!)
    end

    def create_before_direct_upload!(filename:, byte_size:, checksum:, content_type: nil, metadata: nil)
      create! filename: filename, byte_size: byte_size, checksum: checksum, content_type: content_type, metadata: metadata
    end
  end


  def signed_id
    ActiveStorage.verifier.generate(id, purpose: :blob_id)
  end

  def key
    # We can't wait until the record is first saved to have a key for it
    self[:key] ||= self.class.generate_unique_secure_token
  end

  def filename
    ActiveStorage::Filename.new(self[:filename])
  end

  def variant(transformations)
    ActiveStorage::Variant.new(self, ActiveStorage::Variation.new(transformations))
  end

  # Returns the URL of the blob on the service. This URL is intended to be short-lived for security and not used directly
  # with users. Instead, the `service_url` should only be exposed as a redirect from a stable, possibly authenticated URL.
  # Hiding the `service_url` behind a redirect also gives you the power to change services without updating all URLs. And
  # it allows permanent URLs that redirec to the `service_url` to be cached in the view.
  def service_url(expires_in: 5.minutes, disposition: :inline)
    service.url key, expires_in: expires_in, disposition: disposition, filename: filename
  end

  def service_url_for_direct_upload(expires_in: 5.minutes)
    service.url_for_direct_upload key, expires_in: expires_in, content_type: content_type, content_length: byte_size
  end


  def upload(io)
    self.checksum  = compute_checksum_in_chunks(io)
    self.byte_size = io.size

    service.upload(key, io, checksum: checksum)
  end

  def download(&block)
    service.download key, &block
  end


  def delete
    service.delete key
  end

  def purge
    delete
    destroy
  end

  def purge_later
    ActiveStorage::PurgeJob.perform_later(self)
  end


  private
    def compute_checksum_in_chunks(io)
      Digest::MD5.new.tap do |checksum|
        while chunk = io.read(5.megabytes)
          checksum << chunk
        end

        io.rewind
      end.base64digest
    end
end
