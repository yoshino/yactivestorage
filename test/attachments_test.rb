require "test_helper"
require "database/setup"
require "yactivestorage/blob"

# ActiveRecord::Base.logger = Logger.new(STDOUT)

class User < ActiveRecord::Base
  has_one_attached  :avatar
  has_many_attached :highlights
end

class Yactivestorage::AttachmentsTest < ActiveSupport::TestCase
  setup { @user = User.create!(name: "DHH") }

  teardown { Yactivestorage::Blob.all.each(&:purge) }

  test "attach existing blob" do
    @user.avatar.attach create_blob(filename: "funky.jpg")
    binding.pry
    assert_equal "funky.jpg", @user.avatar.filename.to_s
  end

  test "attach new blob" do
    @user.avatar.attach io: StringIO.new("STUFF"), filename: "town.jpg", content_type: "image/jpg"
    assert_equal "town.jpg", @user.avatar.filename.to_s
  end

  test "purge attached blob" do
    @user.avatar.attach create_blob(filename: "funky.jpg")
    avatar_key = @user.avatar.key

    @user.avatar.purge
    assert_not @user.avatar.attached?
    assert_not Yactivestorage::Blob.site.exist?(avatar_key)
  end

  test "attach existing blobs" do
    @user.highlights.attach create_blob(filename: "funky.jpg"), create_blob(filename: "wonky.jpg")

    assert_equal "funky.jpg", @user.highlights.first.filename.to_s
    assert_equal "wonky.jpg", @user.highlights.second.filename.to_s
  end

  test "attach new blobs" do
    @user.highlights.attach(
      { io: StringIO.new("STUFF"), filename: "town.jpg", content_type: "image/jpg" },
      { io: StringIO.new("IT"), filename: "country.jpg", content_type: "image/jpg" })

    assert_equal "town.jpg", @user.highlights.first.filename.to_s
    assert_equal "country.jpg", @user.highlights.second.filename.to_s
  end

  test "purge attached blobs" do
    @user.highlights.attach create_blob(filename: "funky.jpg"), create_blob(filename: "wonky.jpg")
    highlight_keys = @user.highlights.collect(&:key)

    @user.highlights.purge
    assert_not @user.highlights.attached?
    assert_not Yactivestorage::Blob.site.exist?(highlight_keys.first)
    assert_not Yactivestorage::Blob.site.exist?(highlight_keys.second)
  end
end
