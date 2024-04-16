# spec/factories/transactions.rb

FactoryBot.define do
    factory :transaction do
      association :user
      amount { 100 } # Set default amount to 100
      created_at { Date.today }
    end
  end
  