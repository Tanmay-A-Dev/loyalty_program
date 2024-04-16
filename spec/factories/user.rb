# spec/factories/users.rb

FactoryBot.define do
    factory :user do
      sequence(:name) { |n| "User #{n}" }
      birthday { Date.new(1990, 1, 1) }
      points { 0 }
      tier { 'standard' }
    end
  end
  