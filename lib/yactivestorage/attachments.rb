require "yactivestorage/attachment"
require "action_dispatch/http/upload"

module Yactivestorage::Attachments
  def has_file(name)
    define_method(name) do
      (@yactivestorage_attachments ||= {}) [name] ||=
        Yactivestorage::Attachment.find_by(record_gid: to_gid.to_s, name: name)&.tap { |a| a.record = self }
    end

    define_method(:"#{name}=") do |attachable|
      case attachable
      when Yactivestorage::Blob
        blob = attachable
      when ActionDispatch::Http::UploadedFile
        blob = Yactivestorage::Blob.create_after_upload! \
          io: attachable.open,
          filename: attachable.original_filename,
          content_type: attachable.content_type
      when Hash
        blob = Yactivestorage::Blob.create_after_upload!(attachable)
      when NilClass
        blob = nil
      end

      (@yactivestorage_attachments ||= {})[name] = blob ?
        Yactivestorage::Attachment.create!(record_gid: to_gid.to_s, name: name, blob: blob)&.tap { |a| a.record = self } : nil
      end
    end
  end
