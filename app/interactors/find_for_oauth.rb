class FindForOauth
  include Interactor

  PASSWORD_LENGTH = 20

  def call
    context.identity = find_or_create_identity(context.auth)
  end

  private

  def find_or_create_identity(auth)
    find_identity = Identity.where(provider: auth.provider, uid: auth.uid)

    find_identity.first_or_initialize do |identity|
      identity.provider = auth.provider
      identity.uid = auth.uid
      identity.user = find_or_create_user(auth)
      identity.save!
    end
  end

  def find_or_create_user(auth)
    email = auth.info.email
    password = Devise.friendly_token.first(PASSWORD_LENGTH)

    User.find_by(email: email) ||
      User.create!(email: email,
                   password: password,
                   password_confirmation: password)
  end
end
