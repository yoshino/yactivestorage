require "tmpdir"
require "sites/shared_site_tests"

class Yactivestorage::Sites::DiskSiteTest < ActiveSupport::TestCase
  SITE = Yactivestorage::Sites::DiskSite.new(root: File.join(Dir.tmpdir, "yactivestorage"))

  include Yactivestorage::Sites::SharedSiteTests
end
