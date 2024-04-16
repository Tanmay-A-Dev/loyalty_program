class AddFirstTransactionDateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_transaction_date, :datetime
  end
end
