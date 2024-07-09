class ExpensesController < ApplicationController
  def index
    @account_plan = AccountPlan.find(params[:id])
  end
  
  def create_expense
    account_plan_id = params[:account_plan_id]
    name = params[:name]

    expense = Expense.new(account_plan_id:,name:)
    if expense.save
      redirect_to expense_path(expense.account_plan.id)
    end
    
  end

  def edit
    @expense = Expense.find(params[:id])
  end
  
  def show
    @account_plan = AccountPlan.find(params[:id])
  end

  def update
    expense = Expense.find(params[:id])

    if expense.update(expense_params)
      redirect_to expense_path(expense.account_plan.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end
  

  private

  def expense_params
    params.require(:expense).permit(:account_plan_id,:name)
  end
end
