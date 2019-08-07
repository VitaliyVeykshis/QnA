module Helpers
  module ApiHelpers
    def response_json
      @response_json ||= JSON.parse(response.body, symbolize_names: true)
    end

    def do_request(method, path, options = {})
      send method, path, options
    end

    def json_options(options = {})
      user = options[:user] || create(:user)
      addition = options[:addition] || {}
      access_token = options[:access_token] ||
                     create(:access_token, resource_owner_id: user.id)

      { params: { access_token: access_token.token,
                  format: :json }.merge(addition) }
    end
  end
end
