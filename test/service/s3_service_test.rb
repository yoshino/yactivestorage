require "service/shared_service_tests"

if SERVICE_CONFIGURATIONS[:s3]
  class Yactivestorage::Service::S3ServiceTest < ActiveSupport::TestCase
    SERVICE = Yactivestorage::Service.configure(:s3, SERVICE_CONFIGURATIONS)

    include Yactivestorage::Service::SharedServiceTests
  end
else
  puts "Skipping S3 Service tests because no S3 configuration was supplied"
end
