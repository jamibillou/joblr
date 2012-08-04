require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "share_profile" do
    mail = UserMailer.share_profile
    assert_equal "Share profile", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
