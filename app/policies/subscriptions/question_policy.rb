module Subscriptions
  class QuestionPolicy < ApplicationPolicy
    def create?
      user&.persisted? && !record.subscribed?(user)
    end

    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
end
