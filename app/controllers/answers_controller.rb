class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action -> { authorize answer }

  expose :answer, scope: -> { Answer.with_attached_files }
  expose :question, find: -> { find_question }
  expose :answers, -> { question.answers }

  delegate :destroy, to: :answer

  def create
    answers << answer
    answer.user = current_user
    render_errors_json unless answer.save
  end

  def update
    render_errors_json unless answer.update(answer_params)
  end

  def accept
    answer.accept!
  end

  private

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: %i[name url])
  end

  def find_question
    answer&.question || Question.find(params[:question_id])
  end

  def render_errors_json
    render json: answer.errors, status: :unprocessable_entity
  end
end
