require "site/shared_site_tests"

if SITE_CONFIGURATIONS[:s3]
  class Yactivestorage::Site::S3SiteTest < ActiveSupport::TestCase
    SITE = Yactivestorage::Site.configure(:S3, SITE_CONFIGURATIONS[:s3])

    include Yactivestorage::Site::SharedSiteTests
  end
else
  puts "Skipping S3 Site tests because no S3 configuration was supplied"
end
