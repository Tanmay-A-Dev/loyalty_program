class AddMonthlyPointsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :monthly_points, :integer
  end
end
