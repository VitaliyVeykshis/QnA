module Voted
  extend ActiveSupport::Concern

  included do
    expose :resource, -> { controller_name.classify.constantize.find(params[:id]) }
  end

  def vote_up
    resource.vote_up(current_user) unless current_user.author?(resource)

    render_json
  end

  def vote_down
    resource.vote_down(current_user) unless current_user.author?(resource)

    render_json
  end

  private

  def render_json
    render json: {
      rating: resource.rating,
      resource_class: resource.class.to_s,
      resource_id: resource.id
    }
  end
end