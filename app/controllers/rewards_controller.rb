class RewardsController < ApplicationController
    def index
      @user = User.find(params[:user_id])
      @rewards = @user.rewards
    end
  
    def claim
      @reward = Reward.find(params[:id])
      if @reward.claimed_at.nil?
        @reward.update(claimed_at: Time.now)
        redirect_to user_rewards_path(@reward.user), notice: 'Reward claimed successfully.'
      else
        redirect_to user_rewards_path(@reward.user), alert: 'Reward has already been claimed.'
      end
    end

    def new
        @user = User.find(params[:user_id])
        @reward = @user.rewards.new
      end
    
      def create
        @user = User.find(params[:user_id])
        @reward = @user.rewards.new(reward_params)
        if @reward.save
          redirect_to user_rewards_path(@user), notice: 'Reward created successfully.'
        else
          render :new
        end
      end
    
      private
    
      def reward_params
        params.require(:reward).permit(:name)
      end
  end
  