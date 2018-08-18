require "test_helper"
require "database/setup"
require "yactivestorage/blob"

Yactivestorage::Blob.site = Yactivestorage::Site.configure(:Disk, root: File.join(Dir.tmpdir, "yactivestorage"))

class Yactivestorage::BlobTest < ActiveSupport::TestCase
  test "create after upload sets byte size and checksum" do
    data = "Hello world!"
    blob = create_blob data: data

    assert_equal data, blob.download
    assert_equal data.length, blob.byte_size
    assert_equal Digest::MD5.hexdigest(data), blob.checksum
  end

  test "urls expiring in 5 minutes" do
    blob = create_blob

    travel_to Time.now do
      assert_equal expected_url_for(blob), blob.url
      assert_equal expected_url_for(blob, disposition: :attachment), blob.url(disposition: :attachment)
    end
  end

  private
   def create_blob(data: "Hello, World", filename: "hello.txt", content_type: "text/plain")
     Yactivestorage::Blob.create_after_upload! io: StringIO.new(data), filename: filename, content_type: content_type
   end

   def expected_url_for(blob, disposition: :inline)
     "/rails/blobs/#{Yactivestorage::VerifiedKeyWithExpiration.encode(blob.key, expires_in: 5.minutes)}?disposition=#{disposition}"
   end
end
