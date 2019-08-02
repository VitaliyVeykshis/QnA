class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action -> { authorize link }

  expose(:link)

  def destroy
    link.destroy if current_user.author?(link.linkable)
  end
end
