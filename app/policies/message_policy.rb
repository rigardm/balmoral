class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # by default: give access to all houses for the index
      scope.all
    end
  end
  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

end
