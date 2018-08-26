class Yactivestorage::Attached::Many < Yactivestorage::Attached
  delegate_missing_to :attachments

  def attachments
    @attachments ||= Yactivestorage::Attachment.where(record_gid: record.to_gid.to_s, name: name)
  end

  def attach(*attachables)
    @attachments = attachments + Array(attachables).flatten.collect do |attachables|
      Yactivestorage::Attachment.create!(record_gid: record.to_gid.to_s, name: name, blob: create_blob_from(attachables))
    end
  end

  def attached?
    attachments.any?
  end

  def purge
    attachments.each(&:purge)
    @attachments = nil
  end
end
