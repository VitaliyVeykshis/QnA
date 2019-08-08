class Api::V1::ProfilesController < Api::V1::BaseController
  before_action -> { authorize User }

  def index
    render json: UserSerializer.new(users_except_current_user).serialized_json
  end

  def me
    render json: UserSerializer.new(current_resource_owner).serialized_json
  end

  private

  def users_except_current_user
    User.where.not(id: current_resource_owner.id)
  end
end
