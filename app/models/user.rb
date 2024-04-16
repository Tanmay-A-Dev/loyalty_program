class User < ApplicationRecord
  has_many :transactions
  has_many :rewards

  enum tier: { standard: 0, gold: 1, platinum: 2 }

  def birthday_month
    birthday&.month
  end

  def update_points(points)
    update(points: self.points + points)
    update_tier
  end

  def first_transaction_date
    transactions.order(created_at: :asc)&.first&.created_at
  end

  def expire_points
    update(points: 0, points_expiration: Date.today + 1.year)
  end

  def update_tier
    update(tier: :gold) if points >= 1000
    update(tier: :platinum) if points >= 5000
  end

  def check_rewards_eligibility(points)
    check_free_coffee_reward(points)
    check_free_coffee_birthday_reward
    check_cash_rebate_reward
    check_free_movie_tickets_reward
    check_gold_tier_reward
    check_quarterly_bonus_points
  end

  def update_monthly_points(month)
    transactions_this_month = transactions.in_month(month)
    monthly_points = transactions_this_month.sum(:amount) / 100 # Divide by 100 to get points
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

  def check_cash_rebate_reward
    high_value_transactions_count = transactions.where('amount > ?', 100).count
    if high_value_transactions_count >= 10
      rewards.create(name: '5% Cash Rebate')
    end
  end

  def check_free_movie_tickets_reward
    if first_transaction_date.present? && transactions.where('created_at >= ? AND amount > ?', first_transaction_date + 60.days, 1000).exists?
      rewards.create(name: 'Free Movie Tickets')
    end
  end

  def check_gold_tier_reward
    if tier_changed? && tier == 'gold'
      rewards.create(name: '4x Airport Lounge Access')
    end
  end

  def check_quarterly_bonus_points
    quarter_start_date = Date.today.beginning_of_quarter
    quarter_end_date = Date.today.end_of_quarter
    total_spending_in_quarter = transactions.where(created_at: quarter_start_date..quarter_end_date).sum(:amount)
    if total_spending_in_quarter > 2000
      update_points(100)
    end
  end
end
