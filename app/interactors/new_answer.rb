class NewAnswer
  include Interactor

  def call
    answer = context.answer

    answer.question.subscribers.find_each do |user|
      NewAnswerMailer.notify(user, answer).deliver_later
    end
  end
end
