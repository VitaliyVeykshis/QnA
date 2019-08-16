module Helpers
  module ControllerHelpers
    def sign_in_as(user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    def do_request(request_params)
      send request_params.dig(:method),
           request_params.dig(:action),
           params: request_params.dig(:options)
    end
  end
end
