require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "new user email" do
    # Set up an user based on the fixture
    user = users(:one)

    # Set up an email using the user details
    email = UserMailer.with(user: user, password: user.encrypted_password).new_user_email

    # Check if the email is sent
    assert_emails 1 do
      email.deliver_now
    end

    # Check the contents are correct
    assert_equal ["sadhvi.tripathi@ajackus.com"], email.from
    assert_equal ["sadhvi.tripathi@ajackus.com"], email.to
    assert_equal "New user has been created, here are some details", email.subject
    assert_match user.name, email.html_part.body.encoded
    assert_match user.name, email.text_part.body.encoded
    assert_match user.email, email.html_part.body.encoded
    assert_match user.email, email.text_part.body.encoded
    assert_match user.password, email.html_part.body.encoded
    assert_match user.password, email.text_part.body.encoded
  end
end
