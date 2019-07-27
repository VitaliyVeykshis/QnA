class CommentsController < ApplicationController
  before_action :authenticate_user!

  expose :commentable, -> { IdentifyResource.call(params: params).resource }
  expose :comment, scope: -> { commentable.comments }
  expose :question, -> { commentable.is_a?(Question) ? commentable : commentable.question }

  def create
    if comment.save
      broadcast
    else
      render_errors_json
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def render_errors_json
    render json: comment.errors, status: :unprocessable_entity
  end

  def broadcast
    CommentsChannel.broadcast_to(
      question,
      comment: comment.as_json
    )
  end
end
