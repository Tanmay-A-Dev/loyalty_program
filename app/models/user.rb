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

  def first_transaction_date
    transactions.order(created_at: :asc).first.created_at
  end

  def check_rewards_eligibility(points)
    check_free_coffee_reward(points)
    check_free_coffee_birthday_reward
    check_cash_rebate_reward
    check_free_movie_tickets_reward
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

  def check_cash_rebate_reward
    high_value_transactions_count = transactions.where('amount > ?', 100).count
    if high_value_transactions_count >= 10
      rewards.create(name: '5% Cash Rebate')
    end
  end

  def check_free_movie_tickets_reward
    if transactions.where('created_at >= ? AND amount > ?', first_transaction_date + 60.days, 1000).exists?
      rewards.create(name: 'Free Movie Tickets')
    end
  end
end
