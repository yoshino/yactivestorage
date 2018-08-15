require "tmpdir"
require "site/shared_site_tests"

class Yactivestorage::Site::DiskSiteTest < ActiveSupport::TestCase
  SITE = Yactivestorage::Site.configure(:Disk, root: File.join(Dir.tmpdir, "yactivestorage"))

  include Yactivestorage::Site::SharedSiteTests
end
