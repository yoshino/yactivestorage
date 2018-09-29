require "service/shared_service_tests"

class ActiveStorage::Service::ConfiguratorTest < ActiveSupport::TestCase
  test "builds correct service instance based on service name" do
    service = ActiveStorage::Service::Configurator.build(:foo, foo: { service: "Disk", root: "path" })
    assert_instance_of ActiveStorage::Service::DiskService, service
  end

  test "raise error when passing non-extent service name" do
    assert_raise RuntimeError do
      ActiveStorage::Service::Configurator.build(:bigfoot, {})
    end
  end
end
