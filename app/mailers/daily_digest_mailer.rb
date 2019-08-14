class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.created_last_24_hours

    mail to: user.email
  end
end
