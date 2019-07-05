class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :answer, scope: -> { Answer.with_attached_files }
  expose :question, find: -> { answer&.question || Question.find(params[:question_id]) }
  expose :answers, -> { question.answers }

  def create
    answers << answer
    answer.user = current_user
    answer.save
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  def accept
    answer.accept! if current_user.author?(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
