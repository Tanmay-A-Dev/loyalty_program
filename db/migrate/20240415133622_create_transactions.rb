class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.boolean :foreign_transaction, default: false
      
      t.timestamps
    end
  end
end
