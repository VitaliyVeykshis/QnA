module Helpers
  module ApiHelpers
    def response_json
      @response_json ||= JSON.parse(response.body, symbolize_names: true)
    end

    def do_request(method, path, options = {})
      send method, path, options
    end

    def valid_json_options
      @valid_json_options ||= {
        params: { access_token: create(:access_token).token },
        headers: {
          'CONTENT_TYPE' => 'application/json',
          'ACCEPT' => 'application/json'
        }
      }
    end
  end
end
