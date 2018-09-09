require "service/shared_service_tests"

if SITE_CONFIGURATIONS[:gcs]
  class Yactivestorage::Service::GCSServiceTest < ActiveSupport::TestCase
    SERVICE   = Yactivestorage::Service.configure(:GCS, SITE_CONFIGURATIONS[:gcs])

    include Yactivestorage::Service::SharedServiceTests

    test "signed URL generation" do
      travel_to Time.now do
        url = SERVICE.bucket.signed_url(FIXTURE_KEY, expires: 120) +
          "&response-content-disposition=inline%3B+filename%3D%22test.txt%22"

        assert_equal url, @service.url(FIXTURE_KEY, expires_in: 2.minutes, disposition: :inline, filename: "test.txt")
      end
    end
  end
else
  puts "Skipping GCS Service tests because no GCS configuration was supplied"
end
    
