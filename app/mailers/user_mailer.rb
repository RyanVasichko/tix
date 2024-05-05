class UserMailer < ApplicationMailer
  def password_reset_email(user)
    @user = user
    return unless @user

    mail to: @user.email, subject: "Reset your password"
  end
end
