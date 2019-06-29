class AnswersController < ApplicationController
  before_action :authenticate_user!
  expose :question
  expose :answers, ->{ question.answers }
  expose :answer, build: ->{ answers.new(answer_params) }

  def create
    if answer.save
      redirect_to answer.question
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
