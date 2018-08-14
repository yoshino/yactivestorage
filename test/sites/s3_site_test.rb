require "sites/shared_site_tests"

if SITE_CONFIGURATIONS[:s3]
  class Yactivestorage::Sites::S3SiteTest < ActiveSupport::TestCase
    SITE = Yactivestorage::Sites::S3Site.new(SITE_CONFIGURATIONS[:s3])

    include Yactivestorage::Sites::SharedSiteTests
  end
else
  puts "Skipping S3 Site tests because no S3 configuration was supplied"
end
