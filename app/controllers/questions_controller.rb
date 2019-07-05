class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question
  expose :answers, -> { question.answers }
  expose :answer, -> { answers.build }

  def create
    question.user = current_user

    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author?(question)
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      redirect_to questions_path
    else
      redirect_to question
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
