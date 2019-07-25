class AnswersChannel < ApplicationCable::Channel
  def subscribed
    question = Question.find_by(id: params[:question_id])

    question ? stream_for(question) : reject
  end
end
