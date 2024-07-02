class ExpensesController < ApplicationController
  def create
    @account_plan = AccountPlan.find(params[:account_plan_id])
    @expense = @account_plan.expenses.build(expense_params)
    if @expense.save
      redirect_to @account_plan
    else
      render 'account_plans/show'
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount)
  end
end
