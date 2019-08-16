class SubscriptionPolicy < ApplicationPolicy
  def destroy?
    user&.persisted? && record.user_id == user.id
  end
end
