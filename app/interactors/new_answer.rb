class NewAnswer
  include Interactor

  def call
    answer = context.answer
    user = answer.question.user

    NewAnswerMailer.notify(user, answer).deliver_later
  end
end
