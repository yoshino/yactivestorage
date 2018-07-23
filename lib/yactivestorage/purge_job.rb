class Yactivestorage::PurgeJob < ActiveJob::Base
  retry_on Yactivestorage::StorageException

  def perform(blob)
    blob.purge
  end
end
