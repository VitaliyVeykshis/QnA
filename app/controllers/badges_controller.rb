class BadgesController < ApplicationController
  before_action :authenticate_user!

  expose :badges, -> { current_user.badges }
end