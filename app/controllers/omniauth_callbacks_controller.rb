class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    generic_callback('GitHub')
  end

  def vkontakte
    generic_callback('VKontakte')
  end

  private

  def generic_callback(provider)
    user = User.find_for_oauth(request.env['omniauth.auth'])

    if user.confirmed?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session[:oauth_user_id] = user.id
      redirect_to new_oauth_sign_up_path
    end
  end
end
