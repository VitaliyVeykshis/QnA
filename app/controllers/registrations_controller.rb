class RegistrationsController < Devise::RegistrationsController
  expose :user, -> { User.find(session[:oauth_user_id]) }

  def new_oauth_sign_up; end

  def create_oauth_sign_up
    if user.update(email: params[:email])
      redirect_to root_path
    else
      render_errors_json
    end
  end

  private

  def render_errors_json
    render json: user.errors, status: :unprocessable_entity
  end
end
