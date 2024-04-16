class TransactionsController < ApplicationController
    def index
      @user = User.find(params[:user_id])
      @transactions = @user.transactions
    end
  
    def new
      @user = User.find(params[:user_id])
      @transaction = @user.transactions.new
    end
  
    def create
      @user = User.find(params[:user_id])
      @transaction = @user.transactions.new(transaction_params)
      if @transaction.save
        redirect_to user_transactions_path(@user), notice: 'Transaction was successfully recorded.'
      else
        render :new
      end
    end
  
    private
  
    def transaction_params
      params.require(:transaction).permit(:amount, :foreign_transaction)
    end
  end
  