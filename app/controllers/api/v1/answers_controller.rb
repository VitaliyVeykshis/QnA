class Api::V1::AnswersController < Api::V1::BaseController
  before_action -> { authorize answer }

  expose :question, find: -> { find_question }
  expose :answers, -> { question.answers }
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

  def create
    answers << answer
    answer.user = current_user
    if answer.save
      render json: AnswerSerializer.new(answer).serialized_json, status: :created
      broadcast
    else
      render_errors_json
    end
  end

  def update
    answer.update(answer_params) ? (head :no_content) : render_errors_json
  end

  private

  def find_question
    answer&.question || Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: %i[name url])
  end

  def broadcast
    AnswersChannel.broadcast_to(
      question,
      answer: GetAnswerData.call(answer: answer).data
    )
  end

  def render_errors_json
    render json: answer.errors, status: :unprocessable_entity
  end
end
