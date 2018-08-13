require "sites/shared_site_tests"

if SITE_CONFIGURATIONS [:gcs]
  class Yactivestorage::Sites::GCSSiteTest < Yactivestorage::TestCase
    SITE = Yactivestorage::Sites::GCSSite.new(SITE_CONFIGURATIONS[:gcs])

    include Yactivestorage::Sites::SharedSiteTests
  end
else
  puts "Skipping GCS Site tests because no GCS configurations was skipped"
end
