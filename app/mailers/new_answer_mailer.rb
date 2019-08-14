class NewAnswerMailer < ApplicationMailer
  def notify(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email
  end
end
