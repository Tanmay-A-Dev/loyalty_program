class Transaction < ApplicationRecord
  belongs_to :user

  after_create :calculate_points_and_check_rewards_eligibility

  scope :in_month, ->(month) { where("extract(month from created_at) = ?", month) }

  private

  def calculate_points_and_check_rewards_eligibility
    points = amount / 100
    points *= 2 if foreign_transaction?
    user.update_points(points)
    user.check_rewards_eligibility(points)
    user.update_monthly_points(created_at.month)
  end
end
