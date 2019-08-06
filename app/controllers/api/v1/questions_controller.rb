class Api::V1::QuestionsController < Api::V1::BaseController
  before_action -> { authorize Question }

  expose :questions, -> { Question.all }
  expose :question

  SHOW_OPTIONS = {
    include: %i[comments links],
    params: {
      files: true
    }
  }.freeze

  def index
    render json: QuestionSerializer.new(questions).serialized_json
  end

  def show
    render json: QuestionSerializer.new(question, SHOW_OPTIONS).serialized_json
  end
end
