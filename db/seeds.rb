# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create users
user1 = User.create(name: "Tanmay")
user2 = User.create(name: "Tom")

# Create transactions for user1
user1.transactions.create(amount: 150, foreign_transaction: false)
user1.transactions.create(amount: 200, foreign_transaction: true)
user1.transactions.create(amount: 80, foreign_transaction: false)
user1.transactions.create(amount: 120, foreign_transaction: false)
user1.transactions.create(amount: 300, foreign_transaction: true)

# Create transactions for user2
user2.transactions.create(amount: 100, foreign_transaction: false)
user2.transactions.create(amount: 250, foreign_transaction: false)
user2.transactions.create(amount: 90, foreign_transaction: true)
user2.transactions.create(amount: 150, foreign_transaction: false)
user2.transactions.create(amount: 180, foreign_transaction: true)

# Create rewards for user1
user1.rewards.create(name: 'Free Coffee')
user1.rewards.create(name: '5% Cash Rebate')

# Create rewards for user2
user2.rewards.create(name: 'Free Coffee')
user2.rewards.create(name: 'Free Movie Tickets')

# Display seed data
puts "Seed data created successfully:"
puts "Users:"
puts User.pluck(:name).join(", ")
puts "Transactions:"
puts Transaction.pluck(:amount).join(", ")
puts "Rewards:"
puts Reward.pluck(:name).join(", ")
