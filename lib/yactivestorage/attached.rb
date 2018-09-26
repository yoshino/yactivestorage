require "yactivestorage/blob"
require "yactivestorage/attachment"

require "action_dispatch/http/upload"
require "active_support/core_ext/module/delegation"

class Yactivestorage::Attached
  attr_reader :name, :record

  def initialize(name, record)
    @name, @record = name, record
  end

  private
    def create_blob_from(attachable)
      case attachable
      when Yactivestorage::Blob
        attachable
      when ActionDispatch::Http::UploadedFile
        Yactivestorage::Blob.create_after_upload! \
          io: attachable.open,
          filename: attachable.original_filename,
          content_type: attachable.content_type
      when Hash
        Yactivestorage::Blob.create_after_upload!(attachable)
      else
        nil
      end
    end
end

require "yactivestorage/attached/one"
require "yactivestorage/attached/many"
require "yactivestorage/attached/macros"
