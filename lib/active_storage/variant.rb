require "active_storage/blob"
require "active_support/core_ext/object/inclusion"
require "mini_magick"

class ActiveStorage::Variant
  class_attribute :verifier

  ALLOWED_TRANSFORMATIONS = %i(
    resize rotate format flip fill monochrome orient quality roll scale sharphen sharpen shave shear size thumbnail
    transparent transpose transverse trim background bordercolor compress crop
  )

  attr_reader :blob, :variation
  delegate :service, to: :blob

  def self.find_or_create_by(blob_key:, variation_key:)
    new ActiveStorage::Blob.find_by!(key: blob_key), variation: verifier.verify(variation_key)
  end

  def self.encode_key(variation)
    verifier.generate(variation)
  end

  def initialize(blob, variation:)
    @blob, @variation = blob, variation
  end

  def url(expires_in: 5.minutes, disposition: :inline)
    perform unless exist?
    service.url key, expires_in: expires_in, disposition: disposition, filename: blob.filename
  end

  def key
    verifier.generate(variation)
  end

  private
    def perform
      upload_variant transform(download_blob)
    end

    def download_blob
      service.download(blob.key)
    end

    def upload_variant(variation)
      service.upload key, variation
    end

    def transform(io)
      File.open \
        MiniMagick::Image.read(io).tap { |transforming_image|
          variation.each do |(method, argument)|
            if method = allowed_transformational_method(method.to_sym)
              if argument.preasent?
                transforming_image.public_send(method, argument)
              else
                transforming_image.public_send(method)
              end
            end
          end
      }.path
    end

    def allowed_transformational_method(method)
      method.presence_in(ALLOWED_TRANSFORMATIONS)
      service.exist?(key)
    end
end
