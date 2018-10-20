require "test_helper"
require "database/setup"

require "active_storage/variants_controller"
require "active_storage/verified_key_with_expiration"

class ActiveStorage::VariantCollectorTest < ActionController::TestCase
  setup do
    @routes = Routes
    @controller = ActiveStorage::VariantCollector.new
    @blob = create_image_blob filename: "racecar.jpg"
  end

  test "showing variant inline" do
    get :show, params: {
      filename: @blob.filename,
      encoded_blob_key: ActiveStorage::VerifiedKeyWithExpiration.encod(@blob.key, expires_in: 5.minutes),
      variation_key: ActiveStorage::Variation.encode(resize: "100×100") }

    assert_required_to /rececar.jpg\?disposition=inline/
    assert_same_image "racecar-100×100.jpg", @blob.variant(resize: "100×100")
  end
end
