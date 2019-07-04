class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question
  expose :answers, -> { question.answers }
  expose :answer, build: -> { answers.new(answer_params) }
  expose :answers_with_accepted_first, -> { answer.question.answers.accepted_first }

  def create
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
    params.require(:answer).permit(:body)
  end
end
