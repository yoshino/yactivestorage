require "test_helper"
require "database/setup"
require "yactivestorage/blob"
require "yactivestorage/sites/disk_site"

Yactivestorage::Blob.site = Yactivestorage::Sites::DiskSite.new(File.join(Dir.tmpdir, "yactivestorage"))

class Yactivestorage::BlobTest < ActiveSupport::TestCase
  test "create after upload" do
    blob = Yactivestorage::Blob.create_after_upload!(data: StringIO.new("Hello world!"), filename: "hello.txt", content_type: "text/plain")
    assert_equal "Hello world!", blob.download
  end
end
