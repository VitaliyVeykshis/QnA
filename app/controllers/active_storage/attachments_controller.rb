class ActiveStorage::AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { authorize attachment }

  expose :attachment, fetch: -> { ActiveStorage::Attachment.find(params[:id]) }

  def destroy
    attachment.purge if current_user.author?(attachment.record)
  end
end
