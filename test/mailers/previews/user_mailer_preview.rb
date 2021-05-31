# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def new_user_email
    # Set up a temporary order for the preview
    user = User.new(name: "Joe Smith", email: "joe@gmail.com", password: "@Temp1234", role_id: 2)

    UserMailer.with(user: user, password: "@Temp1234").new_user_email
  end
end
