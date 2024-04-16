class User < ApplicationRecord
  has_many :transactions
  has_many :rewards

  enum tier: { standard: 0, gold: 1, platinum: 2 }

  def birthday_month
    birthday.month
  end

  def update_points(points)
    update(points: self.points + points)
    update_tier
  end

  def check_rewards_eligibility(points)
    check_free_coffee_reward(points)
    check_free_coffee_birthday_reward
  end

  def update_monthly_points(month)
    transactions_this_month = transactions.in_month(month)
    monthly_points = transactions_this_month.sum(&:points)
    update(monthly_points: monthly_points)
    check_free_coffee_reward(monthly_points)
  end

  private

  def check_free_coffee_reward(points)
    if points >= 100
      rewards.create(name: 'Free Coffee')
    end
  end

  def check_free_coffee_birthday_reward
    if birthday_month == Date.today.month
      rewards.create(name: 'Free Coffee (Birthday)')
    end
  end
end
