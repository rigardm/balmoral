class SpendingsController < ApplicationController

  def index
    @spendings = policy_scope(Spending).order(created_at: :asc)
  end
end
