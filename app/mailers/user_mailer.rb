class UserMailer < ApplicationMailer
  def new_user_email
    @user = params[:user]
    @password = params[:password]
    p "=====", @user, @password
    p ";;;....", @user.name
    mail(to: @user.email, subject: 'Your password for property App')
  end
end
