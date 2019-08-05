class Api::V1::QuestionsController < Api::V1::BaseController
  before_action -> { authorize Question }

  def index
    render json: QuestionSerializer.new(Question.all).serialized_json
  end
end
