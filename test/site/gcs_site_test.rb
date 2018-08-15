require "site/shared_site_tests"

if SITE_CONFIGURATIONS[:gcs]
  class Yactivestorage::Site::GCSSiteTest < ActiveSupport::TestCase
    SITE = Yactivestorage::Site.configure(:GCS, SITE_CONFIGURATIONS[:gcs])

    include Yactivestorage::Site::SharedSiteTests
  end
else
  puts "Skipping GCS Site tests because no GCS configurations was skipped"
end
