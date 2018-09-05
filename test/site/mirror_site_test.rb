require "tmpdir"
require "site/shared_site_tests"

class Yactivestorage::Site::MirrorSiteTest < ActiveSupport::TestCase
  PRIMARY_DISK_SITE   = Yactivestorage::Site.configure(:Disk, root: File.join(Dir.tmpdir, "yactivestorage"))
  SECONDARY_DISK_SITE = Yactivestorage::Site.configure(:Disk, root: File.join(Dir.tmpdir, "yactivestorage_mirror"))

  SITE = Yactivestorage::Site.configure :Mirror, sites: [ PRIMARY_DISK_SITE, SECONDARY_DISK_SITE ]

  include Yactivestorage::Site::SharedSiteTests


  test "uploading was done to all sites" do
    begin
      key  = SecureRandom.base58(24)
      data = "Something else entirely!"
      io   = StringIO.new(data)
      @site.upload(key, io)

      assert_equal data, PRIMARY_DISK_SITE.download(key)
      assert_equal data, SECONDARY_DISK_SITE.download(key)
    ensure
      @site.delete key
    end
  end

  test "existing in all sites" do
    assert PRIMARY_DISK_SITE.exist?(FIXTURE_KEY)
    assert SECONDARY_DISK_SITE.exist?(FIXTURE_KEY)
  end

  test "URL generation for primary site" do
    travel_to Time.now do
      assert_equal PRIMARY_DISK_SITE.url(FIXTURE_KEY, expires_in: 5.minutes, disposition: :inline, filename: "test.txt"),
        SITE.url(FIXTURE_KEY, eipires_in: 5.minutes, disposition: :inline, filename: "test.txt")
    end
  end
end
