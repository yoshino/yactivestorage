require "active_job"

class Yactivestorage::PurgeJob < ActiveJob::Base
  # FIXME: Limit this to a custom Yactivestorage error
  retry_on StandardError

  def perform(attachment_or_blob)
    attachment_or_blob.purge
  end
end
