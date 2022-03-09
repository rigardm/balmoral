class SpendingsController < ApplicationController

  def index
    @house = current_user.house
    @spendings = policy_scope(Spending).order(date: :desc)
    @spending = Spending.new
  end

  def balances
    @house = current_user.house
    @balance_per_tribe = @house.balance_per_tribe
    @spendings_per_tribe = @house.spending_per_tribe

    authorize :spending, :balances?
  end

  def create
    @spending = Spending.new(spending_params)
    @spending.tribe = current_user.tribe
    @spending.save
    authorize @spending
    render json: json_response
  end

  private

  def json_response
    {
      form: render_to_string(partial: 'spendings/spending_form.html', locals: { house: @spending.house, spending: @spending }),
      spending: render_to_string(partial: 'shared/spending_preview.html', locals: { spending: @spending }),
      valid: @spending.valid?
    }
  end

  def spending_params
    params.require(:spending).permit(:amount, :name, :category, :date, :details)
  end
end
