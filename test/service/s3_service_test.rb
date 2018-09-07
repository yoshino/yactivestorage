require "service/shared_service_tests"

if SITE_CONFIGURATIONS[:s3]
  class Yactivestorage::Service::S3ServiceTest < ActiveSupport::TestCase
    SERVICE = Yactivestorage::Service.configure(:S3, SITE_CONFIGURATIONS[:s3])

    include Yactivestorage::Service::SharedServiceTests
  end
else
  puts "Skipping S3 Service tests because no S3 configuration was supplied"
end
