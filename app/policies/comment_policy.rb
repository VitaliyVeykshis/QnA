class CommentPolicy < ApplicationPolicy
  def create?
    user&.persisted?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
