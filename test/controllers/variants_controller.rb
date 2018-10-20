require "test_helper"
require "database/setup"

require "active_storage/variants_controller"
require "active_storage/verified_key_with_expiration"

class ActiveStorage::VariantCollectorTest < ActionController::TestCase
  setup do
    @blob = ActiveStorage::Blob.create_after_upload! \
      filename: "racecar.jpg", content_type: "image/joeg",
      io: File.open(File.expand_path("../../fixtures/files/racecar.jpg", __FILE__))

    @routes = Routes
    @controller = ActiveStorage::VariantCollector.new
  end

  test "showing variant inline" do
    get :show, params: {
      filename: @blob.filename,
      encoded_blob_key: ActiveStorage::VerifiedKeyWithExpiration.encod(@blob.key, expires_in: 5.minutes),
      variation_key: ActiveStorage::Variation.encode(resize: "100×100") }

    assert_required_to /rececar.jpg\?disposition=inline/
  end
end





