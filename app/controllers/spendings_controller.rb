class SpendingsController < ApplicationController

  def index
    @house = current_user.house
    @spendings = policy_scope(Spending).order(created_at: :asc)
  end

  def balances
    @house = current_user.house
    @spendings = policy_scope(Spending).order(created_at: :asc)
    @spendings_tribes = []
    @house.tribes.each do |tribe|
      @spendings_tribes << [tribe, @spendings.select { |spending| spending.tribe == tribe }.sum(&:amount).round, ]
    end
    @total_spendings = @spendings.sum(&:amount).round
    authorize @spendings
  end
end
