require "test_helper"
require "active_support/core_ext/securerandom"

class Yactivestorage::VerifiedKeyWithExpirationTest < ActiveSupport::TestCase
  FIXTURE_KEY = SecureRandom.base58(24)

  test "without expiration" do
    encoded_key = Yactivestorage::VerifiedKeyWithExpiration.encode(FIXTURE_KEY)
    assert_equal FIXTURE_KEY, Yactivestorage::VerifiedKeyWithExpiration.decode(encoded_key)
  end

  test "with expiration" do
    encoded_key = Yactivestorage::VerifiedKeyWithExpiration.encode(FIXTURE_KEY, expires_in: 1.minute)
    assert_equal FIXTURE_KEY, Yactivestorage::VerifiedKeyWithExpiration.decode(encoded_key)

    travel 2.minutes
    assert_nil Yactivestorage::VerifiedKeyWithExpiration.decode(encoded_key)
  end
end
