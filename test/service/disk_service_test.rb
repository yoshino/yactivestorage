require "tmpdir"
require "service/shared_service_tests"

class Yactivestorage::Service::DiskServiceTest < ActiveSupport::TestCase
  SERVICE = Yactivestorage::Service.configure(:test, test: { service: "Disk", root: File.join(Dir.tmpdir, "yactivestorage") })

  include Yactivestorage::Service::SharedServiceTests
end
