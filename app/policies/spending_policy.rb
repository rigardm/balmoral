class SpendingPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.joins(:tribe).where(tribe: { house: user.house })
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
