require "test_helper"
require "active_support/core_ext/securerandom"
require "yaml"

SITE_CONFIGURATIONS = begin
  YAML.load_file(File.expand_path("../configurations.yml", __FILE__)).deep_symbolize_keys
rescue Errno::ENOENT
  puts "Missing service configurations file in test/service/configurations.yml"
end

module Yactivestorage::Service::SharedServiceTests
  extend ActiveSupport::Concern

  FIXTURE_KEY  = SecureRandom.base58(24)
  FIXTURE_FILE = StringIO.new("Hello world!")

  included do
    setup do
      @service = self.class.const_get(:SERVICE)
      @service.upload FIXTURE_KEY, FIXTURE_FILE
      FIXTURE_FILE.rewind
    end

    teardown do
      @service.delete FIXTURE_KEY
      FIXTURE_FILE.rewind
    end

    test "uploading with integrity" do
      begin
        key  = SecureRandom.base58(24)
        data = "Something else entirely!"
        @service.upload(key, StringIO.new(data), checksum: Digest::MD5.base64digest(data))

        assert_equal data, @service.download(key)
      ensure
        @service.delete key
      end
    end

    test "upload without integrity" do
      begin
        key = SecureRandom.base58(24)
        data = "Something else entirely!"

        assert_raises(Yactivestorage::IntegrityError) do
          @service.upload(key, StringIO.new(data), checksum: Digest::MD5.base64digest("bad data"))
        end
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

    test "deleting nonexistent key" do
      @service.delete SecureRandom.base58(24)
    end
  end
end
