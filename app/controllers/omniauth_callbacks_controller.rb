class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    generic_callback('GitHub')
  end

  private

  def generic_callback(provider)
    user = User.find_for_oauth(request.env['omniauth.auth'])

    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
  end
end
