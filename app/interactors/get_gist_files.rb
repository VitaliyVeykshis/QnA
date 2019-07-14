class GetGistFiles
  include Interactor

  def call
    access_token = Rails.application.credentials.dig(:github, :personal_access_token)
    client = Octokit::Client.new(access_token: access_token)
    context.gist_files = gist_files(client)
  end

  private

  def gist_files(client)
    client.gist(gist_id).files.to_hash.values
  rescue Octokit::NotFound
    nil
  end

  def gist_id
    context.gist_url.split('/').last
  end
end
