module OmniauthMacros
  def github_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '123456',
      info: { email: 'user@mail.com' }
    )
  end
end
