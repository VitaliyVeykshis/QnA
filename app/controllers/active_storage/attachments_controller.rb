class ActiveStorage::AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { authorize attachment }

  expose :attachment, fetch: -> { find_attachment }

  def destroy
    attachment.purge
  end

  private

  def find_attachment
    ActiveStorage::Attachment.find(params[:id])
  end
end
