class ActiveStorage::AttachmentPolicy < ApplicationPolicy
  def destroy?
    user&.author?(record.record)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
