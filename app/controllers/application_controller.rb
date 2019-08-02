class ApplicationController < ActionController::Base
  include Pundit

  before_action :gon_user
  after_action :verify_authorized, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  respond_to :html, :js, :json

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end

  def user_not_authorized
    error_message = 'You are not authorized to perform this action.'
    flash[:alert] = error_message

    respond_with do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js { render action_name.to_sym, status: :forbidden }
      format.json { render json: { message: error_message }, status: :forbidden }
    end
  end
end
