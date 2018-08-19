require "bundler/setup"
require "active_support"
require "active_support/testing/autorun"
require "active_support/test_case"
require "pry"

require "yactivestorage"

require "yactivestorage/site"
Yactivestorage::Blob.site = Yactivestorage::Site.configure(:Disk, root: File.join(Dir.tmpdir, "yactivestorage"))

require "yactivestorage/verified_key_with_expiraion"
Yactivestorage::VerifiedKeyWithExpiration.verifier = ActiveSupport::MessageVerifier.new("Testing")

class ActiveSupport::TestCase
  private
    def create_blob(data: "Hello, World", filename: "hello.txt", content_type: "text/plain")
      Yactivestorage::Blob.create_after_upload! io: StringIO.new(data), filename: filename, content_type: content_type
    end
end
