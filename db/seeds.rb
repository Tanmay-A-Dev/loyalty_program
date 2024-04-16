# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Create users with different scenarios for testing loyalty rules

# User 1: Standard tier with points expiring soon
user1 = User.create(name: 'John', points: 500, points_expiration: Date.today + 6.months)

# User 2: Gold tier with upcoming points expiration
user2 = User.create(name: 'Alice', points: 1200, tier: :gold, points_expiration: Date.today + 9.months)

# User 3: Platinum tier with points expiring far in the future
user3 = User.create(name: 'Bob', points: 6000, tier: :platinum, points_expiration: Date.today + 2.years)

# User 4: New user with first transaction date and birthday in current month
user4 = User.create(name: 'Eva', first_transaction_date: Date.today - 10.days, birthday: Date.today)

# Create transactions for users

# Transactions for user1
user1.transactions.create(amount: 500) # This transaction adds 5 points
user1.transactions.create(amount: 1500, foreign_transaction: true) # This transaction adds 30 points (2x points for foreign transaction)

# Transactions for user2
user2.transactions.create(amount: 200) # This transaction adds 2 points
user2.transactions.create(amount: 1000) # This transaction adds 10 points
user2.transactions.create(amount: 1500) # This transaction adds 15 points
user2.transactions.create(amount: 3000) # This transaction adds 30 points

# Transactions for user3
user3.transactions.create(amount: 500) # This transaction adds 5 points

# Transactions for user4
user4.transactions.create(amount: 1000) # This transaction adds 10 points
user4.transactions.create(amount: 1500) # This transaction adds 15 points
user4.transactions.create(amount: 3000) # This transaction adds 30 points
user4.transactions.create(amount: 2500) # This transaction adds 25 points

# Reward for user1 (Standard tier)
user1.rewards.create(name: 'Free Coffee')

# Reward for user2 (Gold tier)
user2.rewards.create(name: 'Free Coffee (Birthday)')
user2.rewards.create(name: '4x Airport Lounge Access')

# Reward for user3 (Platinum tier)
user3.rewards.create(name: 'Free Coffee (Birthday)')
user3.rewards.create(name: '4x Airport Lounge Access')
user3.rewards.create(name: 'Free Movie Tickets')