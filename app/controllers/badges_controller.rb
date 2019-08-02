class BadgesController < ApplicationController
  before_action :authenticate_user!
  before_action -> { authorize badges }

  expose :badges, -> { current_user.badges }
end