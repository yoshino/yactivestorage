require "service/shared_service_tests"

class ActiveStorage::Service::ConfiguratorTest < ActiveSupport::TestCase
  test "builds correct service instance based on service name" do
    service = ActiveStorage::Service::Configurator.build(:s3, SERVICE_CONFIGURATIONS)
    assert_instance_of ActiveStorage::Service::S3Service, service
  end

  test "raise error when passing non-extent service name" do
    assert_raise RuntimeError do
      ActiveStorage::Service::Configurator.build(:bigfoot, SERVICE_CONFIGURATIONS)
    end
  end
end
