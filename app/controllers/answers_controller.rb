class AnswersController < ApplicationController
  before_action :authenticate_user!
  expose :question
  expose :answers, ->{ question.answers }
  expose :answer, build: ->{ answers.new(answer_params) }

  def create
    answer.user = current_user

    if answer.save
      redirect_to answer.question
    else
      render 'questions/show'
    end
  end

  def destroy
    answer.destroy if current_user.author?(answer)

    redirect_to answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
