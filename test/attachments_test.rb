require "test_helper"
require "database/setup"
require "yactivestorage/blob"

# Yactivestorage::Base.logger = Logger.new(STDOUT)

class User < ActiveRecord::Base
  has_file :avatar
end

class Yactivestorage::AttachmentsTest < ActiveSupport::TestCase
  setup { @user = User.create!(name: "DHH") }

  test "create attachment from existing blob" do
    @user.avatar = create_blob filename: "funny.jpg"
    assert_equal "funny.jpg", @user.avatar.filename.to_s
  end

  test "purge attached blob" do
    @user.avatar = create_blob filename: "funny.jpg"
    avatar_key = @user.avatar.key

    @user.avatar.purge
    assert_nil @user.avatar
    assert_not Yactivestorage::Blob.site.exist?(avatar_key)
  end
end
