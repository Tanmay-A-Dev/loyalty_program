class User < ApplicationRecord
    has_many :transactions
    has_many :rewards
end
