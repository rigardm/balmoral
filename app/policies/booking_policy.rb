class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(house: user.house)
    end
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    # update is authorized if current user is EITHER:
    # (i) the user who made the booking
    # OR
    # (ii) the admin of the tribe of that user
    (user == record.user) || record.user.tribe.users.admins.include?(user)
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
