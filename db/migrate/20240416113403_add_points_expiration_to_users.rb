class AddPointsExpirationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :points_expiration, :date
  end
end
