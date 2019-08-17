class SubscriptionsController < ApplicationController
  expose :subscription
  expose :question, -> { set_question }

  def create
    authorize [:subscriptions, question]

    question.subscribe(current_user)
    flash[:notice] = 'You have successfully subscribed.'
    redirect_to question
  end

  def destroy
    authorize subscription

    subscription.destroy
    flash[:notice] = 'You have successfully unsubscribed.'
    redirect_to question
  end

  private

  def set_question
    subscription&.question || Question.find(params[:question_id])
  end
end
