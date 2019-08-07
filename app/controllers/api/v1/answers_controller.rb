class Api::V1::AnswersController < Api::V1::BaseController
  before_action -> { authorize Answer }

  expose :question, find: -> { find_question }
  expose :answer

  def index
    render json: AnswerSerializer.new(question.answers).serialized_json
  end

  private

  def find_question
    answer&.question || Question.find(params[:question_id])
  end
end
