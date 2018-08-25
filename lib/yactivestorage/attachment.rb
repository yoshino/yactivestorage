require "yactivestorage/blob"
require "global_id"
require "active_support/core_ext/module/delegation"

class Yactivestorage::Attachment < ActiveRecord::Base
  self.table_name = "yactivestorage_attachments"

  belongs_to :blob, class_name: "Yactivestorage::Blob"

  delegate_missing_to :blob

  def record
    @record ||= GlobalID::Locator.locate(record_gid)
  end

  def record=(record)
    @record = record
    self.record_gid = record&.to_gid
  end

  def purge
    blob.purge
    destroy
    record.public_send "#{name}=", nil
  end
end
