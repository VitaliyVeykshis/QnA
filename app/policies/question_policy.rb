class QuestionPolicy < ApplicationPolicy
  include VotedPolicy

  def index?
    true
  end

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

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
