class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action -> { question.badge = Badge.new }, only: :new
  before_action -> { gon.question_id = question.id }, only: :show

  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }
  expose :answers, -> { question.answers }
  expose :answer, -> { answers.build }

  def create
    question.user = current_user

    if question.save
      redirect_to question, notice: 'Your question successfully created.'
      broadcast
    else
      render_errors_json
    end
  end

  def update
    if current_user.author?(question)
      render_errors_json unless question.update(question_params)
    end
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
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[name url],
                                     badge_attributes: %i[title image])
  end

  def render_errors_json
    render json: question.errors, status: :unprocessable_entity
  end

  def broadcast
    ActionCable.server.broadcast('questions', question: question.as_json)
  end
end
