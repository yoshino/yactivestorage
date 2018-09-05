require "tmpdir"
require "service/shared_service_tests"

class Yactivestorage::Service::MirrorServiceTest < ActiveSupport::TestCase
  PRIMARY_DISK_SITE   = Yactivestorage::Service.configure(:Disk, root: File.join(Dir.tmpdir, "yactivestorage"))
  SECONDARY_DISK_SITE = Yactivestorage::Service.configure(:Disk, root: File.join(Dir.tmpdir, "yactivestorage_mirror"))

  SITE = Yactivestorage::Service.configure :Mirror, services: [ PRIMARY_DISK_SITE, SECONDARY_DISK_SITE ]

  include Yactivestorage::Service::SharedServiceTests


  test "uploading was done to all services" do
    begin
      key  = SecureRandom.base58(24)
      data = "Something else entirely!"
      io   = StringIO.new(data)
      @service.upload(key, io)

      assert_equal data, PRIMARY_DISK_SITE.download(key)
      assert_equal data, SECONDARY_DISK_SITE.download(key)
    ensure
      @service.delete key
    end
  end

  test "existing in all services" do
    assert PRIMARY_DISK_SITE.exist?(FIXTURE_KEY)
    assert SECONDARY_DISK_SITE.exist?(FIXTURE_KEY)
  end

  test "URL generation for primary service" do
    travel_to Time.now do
      assert_equal PRIMARY_DISK_SITE.url(FIXTURE_KEY, expires_in: 5.minutes, disposition: :inline, filename: "test.txt"),
        SITE.url(FIXTURE_KEY, expires_in: 5.minutes, disposition: :inline, filename: "test.txt")
    end
  end
end
