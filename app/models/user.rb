class User < ApplicationRecord
  has_many :transactions
  has_many :rewards

  enum tier: { standard: 0, gold: 1, platinum: 2 }

  def birthday_month
    birthday&.month
  end

  def update_points(points)
    new_points = self.points + points
    update_attributes_with_tier_check(points: new_points)
  end

  def first_transaction_date
    transactions.minimum(:created_at)
  end

  def expire_points
    update(points: 0, points_expiration: 1.year.from_now.to_date)
  end

  def update_tier
    update(tier: :gold) if points >= 1000 && tier != 'gold'
    update(tier: :platinum) if points >= 5000 && tier != 'platinum'
  end

  def check_rewards_eligibility
    check_free_coffee_reward
    check_free_coffee_birthday_reward
    check_cash_rebate_reward
    check_free_movie_tickets_reward
    check_gold_tier_reward
    check_quarterly_bonus_points
  end

  def update_monthly_points(month)
    transactions_this_month = transactions.in_month(month)
    monthly_points = transactions_this_month.sum(:amount) / 100 # Divide by 100 to get points
    update_attributes_with_coffee_reward(monthly_points: monthly_points)
  end

  private

  def update_attributes_with_tier_check(attributes)
    update(attributes)
    update_tier
  end

  def update_attributes_with_coffee_reward(attributes)
    update(attributes)
    check_free_coffee_reward(attributes[:monthly_points])
  end

  def check_free_coffee_reward(points)
    rewards.create(name: 'Free Coffee') if points >= 100
  end

  def check_free_coffee_birthday_reward
    rewards.create(name: 'Free Coffee (Birthday)') if birthday_month == Date.today.month
  end

  def check_cash_rebate_reward
    rewards.create(name: '5% Cash Rebate') if high_value_transactions_count >= 10
  end

  def check_free_movie_tickets_reward
    rewards.create(name: 'Free Movie Tickets') if first_transaction_over_1000_within_60_days?
  end

  def check_gold_tier_reward
    rewards.create(name: '4x Airport Lounge Access') if tier_changed? && tier == 'gold'
  end

  def check_quarterly_bonus_points
    update_points(100) if total_spending_in_quarter > 2000
  end

  def high_value_transactions_count
    transactions.where('amount > ?', 100).count
  end

  def first_transaction_over_1000_within_60_days?
    transactions.where('created_at >= ? AND amount > ?', first_transaction_date + 60.days, 1000).exists?
  end

  def total_spending_in_quarter
    quarter_start_date = Date.today.beginning_of_quarter
    quarter_end_date = Date.today.end_of_quarter
    transactions.where(created_at: quarter_start_date..quarter_end_date).sum(:amount)
  end
end
