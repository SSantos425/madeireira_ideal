class AccountPlansController < ApplicationController
  def index
    @account_plans = AccountPlan.all
  end

  def show
    @account_plan = AccountPlan.find(params[:id])
  end

  def new
    @account_plan = AccountPlan.new
  end

  def create
    @account_plan = AccountPlan.new(account_plan_params)
    if @account_plan.save
      redirect_to @account_plan
    else
      render :new
    end
  end

  private

  def account_plan_params
    params.require(:account_plan).permit(:name)
  end
end
