require "test_helper"
require "database/setup"

require "action_controller"
require "yactivestorage/disk_controller"
require "yactivestorage/verified_key_with_expiration"

class Yactivestorage::DiskControllerTest < ActionController::TestCase
  Routes = ActionDispatch::Routing::RouteSet.new.tap do |routes|
    routes.draw do
      get "/rails/blobs/:encoded_key" => "yactivestorage/disk#show", as: :rails_disk_blob
    end
  end

  setup do
    @blob = create_blob
    @routes = Routes
    @controller = Yactivestorage::DiskController.new
  end

  test "showing blob inline" do
    get :show, params: { encoded_key: Yactivestorage::VerifiedKeyWithExpiration.encode(@blob.key, expires_in: 5.minutes) }
    assert_equal "inline; filename=\"#{@blob.filename}\"", @response.headers["Content-Disposition"]
    assert_equal "text/plain", @response.headers["Content-Type"]
  end

  test "showing blob as attachment" do
    get :show, params: { encoded_key: Yactivestorage::VerifiedKeyWithExpiration.encode(@blob.key, expires_in: 5.minutes), disposition: :attachment }
    assert_equal "attachment; filename=\"#{@blob.filename}\"", @response.headers["Content-Disposition"]
    assert_equal "text/plain", @response.headers["Content-Type"]
  end
end
