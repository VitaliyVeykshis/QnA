class UserPolicy < ApplicationPolicy
  def me?
    user&.persisted?
  end

  def index?
    me?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
