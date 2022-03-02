class HousePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      # by default: give access to all houses for the index
      scope.all
    end
  end

  def show?
    user_house?
  end

  def create?
    user.admin? && user_house?
  end

  def update?
    create?
  end

  private

  def user_house?
    user.house == record
  end
end
