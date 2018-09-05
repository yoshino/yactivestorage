require "test_helper"
require "active_support/core_ext/securerandom"
require "yaml"

SITE_CONFIGURATIONS = begin
  YAML.load_file(File.expand_path("../configurations.yml", __FILE__)).deep_symbolize_keys
rescue Errno::ENOENT
  puts "Missing service configurations file in test/services/configurations.yml"
end

module Yactivestorage::Service::SharedServiceTests
  extend ActiveSupport::Concern

  FIXTURE_KEY  = SecureRandom.base58(24)
  FIXTURE_FILE = StringIO.new("Hello world!")

  included do
    setup do
      @service = self.class.const_get(:SITE)
      @service.upload FIXTURE_KEY, FIXTURE_FILE
      FIXTURE_FILE.rewind
    end

    teardown do
      @service.delete FIXTURE_KEY
      FIXTURE_FILE.rewind
    end

    test "uploading" do
      begin
        key  = SecureRandom.base58(24)
        data = "Something else entirely!"
        @service.upload(key, StringIO.new(data))

        assert_equal data, @service.download(key)
      ensure
        @service.delete key
      end
    end

    test "downloading" do
      assert_equal FIXTURE_FILE.read, @service.download(FIXTURE_KEY)
    end

    test "existing" do
      assert @service.exist?(FIXTURE_KEY)
      assert_not @service.exist?(FIXTURE_KEY + "nonsense")
    end

    test "deleting" do
      @service.delete FIXTURE_KEY
      assert_not @service.exist?(FIXTURE_KEY)
    end

    test "sizing" do
      assert_equal FIXTURE_FILE.size, @service.byte_size(FIXTURE_KEY)
    end

    test "checksumming" do
      assert_equal Digest::MD5.hexdigest(FIXTURE_FILE.read), @service.checksum(FIXTURE_KEY)
    end
  end
end
