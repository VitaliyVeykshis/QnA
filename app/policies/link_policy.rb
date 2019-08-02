class LinkPolicy < ApplicationPolicy
  def destroy?
    user.author?(record.linkable) if user&.persisted?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
