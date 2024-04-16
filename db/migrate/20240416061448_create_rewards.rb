class CreateRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :rewards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.datetime :claimed_at

      t.timestamps
    end
  end
end
