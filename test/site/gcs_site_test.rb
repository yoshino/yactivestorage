require "site/shared_site_tests"

if SITE_CONFIGURATIONS[:gcs]
  class Yactivestorage::Site::GCSSiteTest < ActiveSupport::TestCase
    SITE   = Yactivestorage::Site.configure(:GCS, SITE_CONFIGURATIONS[:gcs])
    SIGNER = Google::Cloud::Storage::File::Signer.from_bucket(SITE.bucket, Yactivestorage::Site::SharedSiteTests::FIXTURE_KEY)

    include Yactivestorage::Site::SharedSiteTests

    test "signed URL generation" do
      travel_to Time.now do
        assert_equal SIGNER.signed_url(expires: 120) + "&response-content-disposition=inline%3B+filename%3D%22test.txt%22",
          @site.url(FIXTURE_KEY, expires_in: 2.minutes, disposition: :inline, finename: "test.txt")
      end
    end
  end
else
  puts "Skipping GCS Site tests because no GCS configurations was skipped"
end
