class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :points, default: 0
      t.integer :tier, default: 0

      t.timestamps
    end
  end
end
