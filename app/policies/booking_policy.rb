class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(house: user.house)
    end
  end

  def show?
    user_house?
  end

  def create?
    user_house?
  end

  def new?
    create?
  end

  def update?
    user == record.user || user == record.user.tribe.admin
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def find_booking?
    show?
  end

  private

  def user_house?
    user.house == record.house
  end
end
