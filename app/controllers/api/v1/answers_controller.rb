class Api::V1::AnswersController < Api::V1::BaseController
  before_action -> { authorize Answer }

  expose :question, find: -> { find_question }
  expose :answer

  SHOW_OPTIONS = {
    include: %i[comments links],
    params: {
      files: true
    }
  }.freeze

  def index
    render json: AnswerSerializer.new(question.answers).serialized_json
  end

  def show
    render json: AnswerSerializer.new(answer, SHOW_OPTIONS).serialized_json
  end

  private

  def find_question
    answer&.question || Question.find(params[:question_id])
  end
end
