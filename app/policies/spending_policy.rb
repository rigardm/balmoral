class SpendingPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.joins(:tribe).where(tribe: { house: user.house })
    end
  end

  def balances?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end
end
