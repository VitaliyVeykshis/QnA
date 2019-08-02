class AnswerPolicy < ApplicationPolicy
  include VotedPolicy

  def show?
    true
  end

  def create?
    user&.persisted?
  end

  def update?
    user.author?(record) if create?
  end

  def destroy?
    update?
  end

  def accept?
    user&.author?(record&.question) && !record.accepted?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
