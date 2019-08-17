class Api::V1::QuestionsController < Api::V1::BaseController
  before_action -> { authorize question }

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

  def create
    question.user = current_resource_owner

    if question.save
      render json: QuestionSerializer.new(question).serialized_json, status: :created
    else
      render_errors_json
    end
  end

  def update
    question.update(question_params) ? (head :no_content) : render_errors_json
  end

  def destroy
    message = 'Question deleted.'
    render json: { message: message }, status: :ok if question.destroy
  end

  private

  def render_errors_json
    render json: question.errors, status: :unprocessable_entity
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     links_attributes: %i[name url])
  end
end
