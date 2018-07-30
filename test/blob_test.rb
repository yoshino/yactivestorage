require "test_helper"
require "database/setup"
require "yactivestorage/blob"

Yactivestorage::Blob.site = Yactivestorage::Sites::DiskSite.new(File.join(Dir.tmpdir, "yactivestorage"))

class Yactivestorage::BlobTest < ActiveSupport::TestCase
  test "create after upload sets byte size and checksum" do
    data = "Hello world!"
    blob = Yactivestorage::Blob.create_after_upload! data: StringIO.new(data), filename: "hello.txt", content_type: "text/plain"

    assert_equal data, blob.download
    assert_equal data.length, blob.byte_size
    assert_equal Digest::MD5.hexdigest(data), blob.checksum
  end
end
