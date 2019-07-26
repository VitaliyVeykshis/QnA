class CommentsController < ApplicationController
  before_action :authenticate_user!

  expose :commentable, -> { IdentifyResource.call(params: params).resource }
  expose :comment, scope: -> { commentable.comments }

  def create
    render_errors_json unless comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def render_errors_json
    render json: comment.errors, status: :unprocessable_entity
  end
end
