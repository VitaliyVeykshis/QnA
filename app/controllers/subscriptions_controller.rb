class SubscriptionsController < ApplicationController
  before_action -> { authorize [:subscriptions, question] }

  expose :subscription
  expose :question, -> { set_question }

  def create
    question.subscribe(current_user)
    flash[:notice] = 'You have successfully subscribed.'
    redirect_to question
  end

  private

  def set_question
    subscription&.question || Question.find(params[:question_id])
  end
end
