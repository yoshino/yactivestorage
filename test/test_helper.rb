require "bundler/setup"
require "active_support"
require "active_support/test_case"
require "active_support/testing/autorun"
require "byebug"

require "yactivestorage"
require "yactivestorage/service/disk_service"
Yactivestorage::Blob.service = Yactivestorage::Service::DiskService.new(root: File.join(Dir.tmpdir, "yactivestorage"))
Yactivestorage::Service.logger = ActiveSupport::Logger.new(STDOUT)

require "yactivestorage/verified_key_with_expiration"
Yactivestorage::VerifiedKeyWithExpiration.verifier = ActiveSupport::MessageVerifier.new("Testing")

class ActiveSupport::TestCase
  private
    def create_blob(data: "Hello world!", filename: "hello.txt", content_type: "text/plain")
      Yactivestorage::Blob.create_after_upload! io: StringIO.new(data), filename: filename, content_type: content_type
    end
end


require "yactivestorage/attached"
ActiveRecord::Base.send :extend, Yactivestorage::Attached::Macros

require "global_id"
GlobalID.app = "YactivestorageExampleApp"
ActiveRecord::Base.send :include, GlobalID::Identification
