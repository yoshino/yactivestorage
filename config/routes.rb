Rails.application.routes.draw do
  get  "/rails/active_storage/blobs/:sigend_id/*filename" => "active_storage/blobs#show"
  
  direct :rails_blob do |blob|
    route_for(:rails_service_blob, blob.sigend_id, blob.filename)
  end

  resolve("ActiveStorage::Blob") { |blob| route_for(:rails_blob, blob) }
  resolve("ActiveStorage::Attachment") { |attachmebt| route_for(:rails_blob, attachmebt.blob) }

  get  "/rails/active_storage/variants/:signed_blob_id/:variation_key/*filename" => "active_storage/variants#show", as: :rails_blob_variation

  direct :rails_variant do |variant|
    signed_id        = variant.blob.signed_id
    variation_key    = variant.variation.key
    filename         = variant.blob.filename

    route_for(:rails_blob_variation, signed_blob_id, variation_key, filename)
  end

  resolve ("ActiveStorage::Variant") { |variant| route_for(:rails_variant, variant) }

  get  "/rails/active_storage/disk/:encoded_key/*filename" => "active_storage/disk#show", as: :rails_disk_blob
  post "/rails/active_storage/direct_uploads" => "active_storage/direct_uploads#create", as: :rails_direct_uploads
end
