class AccountPlansController < ApplicationController
  def index
    @account_plans = AccountPlan.order(created_at: :asc)
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
      redirect_to account_plans_path, notice: 'Centro de Custo Cadastrado com Sucesso !!'
    else
      render :new
    end
  end

  def edit
    @account_plan = AccountPlan.find(params[:id])
  end

  def update
    @account_plan = AccountPlan.find(params[:id])

    if @account_plan.update(account_plan_params)
      redirect_to account_plans_path, notice: 'Centro de custo Cadastrado com Sucesso !!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    account_plan = AccountPlan.find(params[:id])
    account_plan.destroy
    redirect_to account_plans_path, notice: 'Centro de custo Deletado com Sucesso !!.'
  end

  private

  def account_plan_params
    params.require(:account_plan).permit(:name)
  end
end
