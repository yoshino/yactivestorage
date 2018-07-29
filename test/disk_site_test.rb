require "test_helper"
require "fileutils"
require "tmpdir"
require "active_support/core_ext/securerandom"
require "yactivestorage/site"

class Yactivestorage::DiskSiteTest < ActiveSupport::TestCase
  FIXTURE_KEY = SecureRandom.base58(24)
  FIXTURE_FILE = StringIO.new("Hello world!")

  setup do
    @site = Yactivestorage::Sites::DiskSite.new(File.join(Dir.tmpdir, "yactivestorage"))
    @site.upload FIXTURE_KEY, FIXTURE_FILE
    FIXTURE_FILE.rewind
  end

  teardown do # 各テストの後の処理
    FileUtils.rm_rf @site.root
    FIXTURE_FILE.rewind
  end

  test "downloading" do
    assert_equal FIXTURE_FILE.read, @site.download(FIXTURE_KEY)
  end

  test "existing" do
    assert @site.exists?(FIXTURE_KEY)
    assert_not @site.exists?(FIXTURE_KEY + "nonsense")
  end

  test "deleting" do
    @site.delete FIXTURE_KEY
    assert_not @site.exists?(FIXTURE_KEY)
  end

  test "sizing" do
    assert_equal FIXTURE_FILE.size, @site.size(FIXTURE_KEY)
  end

  test "checksumming" do
    assert_equal Digest::MD5.hexdigest(FIXTURE_FILE.read), @site.checksum(FIXTURE_KEY)
  end
end
