require "bundler/setup"
require "active_support"
require "active_support/testing/autorun"
require "pry"

require "yactivestorage"

require "yactivestorage/site"
Yactivestorage::Blob.site = Yactivestorage::Sites::DiskSite.new(root: File.join(Dir.tmpdir, "yactivestorage"))

require "yactivestorage/verified_key_with_expiraion"
Yactivestorage::VerifiedKeyWithExpiration.verifier = ActiveSupport::MessageVerifier.new("Testing")
