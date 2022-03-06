class SpendingPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(tribe: user.tribe)
    end
  end

  def show?
    user_house?
  end

  def index
    user.tribe.admin? && user_house?
  end

  private

  def user_house?
    user.house == record.house
  end

end
