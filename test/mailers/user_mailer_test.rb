require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "new user email" do

    # Set up an email using the user details
    # email = UserMailer.with(user: { name: "test", email: "test@test.com" }, password: "Temp1234").new_user_email.deliver_now

    # Check the contents are correct
    # assert_equal "New user has been created, here are some details", email.subject
    # assert_match user.name, email.text_part.body.encoded
    # assert_match user.email, email.text_part.body.encoded
    # assert_match user.password, email.text_part.body.encoded
  end
end
