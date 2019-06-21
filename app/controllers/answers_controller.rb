class AnswersController < ApplicationController
  expose :question
  expose :answers, ->{ question.answers }
  expose :answer, build: ->{ answers.new(answer_params) }

  def create
    if answer.save
      redirect_to answer.question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
