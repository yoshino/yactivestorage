class Yactivestorage::Attached::One < Yactivestorage::Attached
  delegate_missing_to :attachment
   def attachment
    @attachment ||= Yactivestorage::Attachment.find_by(record_gid: record.to_gid.to_s, name: name)
  end

  def attach(attachable)
     @attachment = Yactivestorage::Attachment.create!(record_gid: record.to_gid.to_s, name: name, blob: create_blob_from(attachable))
  end

  def attached?
    attachment.present?
  end

  def purge
     if attached?
      attachment.purge
      @attachment = nil
    end
  end

  def purge_later
    if attached?
      attachment.purge_later
      @attachment = nil
    end
  end
end
