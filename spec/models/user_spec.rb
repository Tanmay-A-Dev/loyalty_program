require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#birthday_month' do
    it 'returns the month of the user\'s birthday' do
      user = build(:user, birthday: Date.new(1990, 5, 15))
      expect(user.birthday_month).to eq(5)
    end

    it 'returns nil if the user\'s birthday is not set' do
      user = build(:user, birthday: nil)
      expect(user.birthday_month).to be_nil
    end
  end

  describe '#update_points' do
    let(:user) { create(:user, points: 500) }

    it 'adds points to the user' do
      user.update_points(100)
      expect(user.points).to eq(600)
    end

    it 'updates tier if points reach gold level' do
      expect { user.update_points(500) }.to change { user.tier }.from('standard').to('gold')
    end

    it 'updates tier if points reach platinum level' do
      expect { user.update_points(5000) }.to change { user.tier }.from('standard').to('platinum')
    end
  end

  describe '#first_transaction_date' do
    it 'returns the date of the user\'s first transaction' do
      user = create(:user)
      transaction = create(:transaction, user: user, created_at: Date.new(2023, 1, 1))
      expect(user.first_transaction_date).to eq(transaction.created_at)
    end
  end

  describe '#expire_points' do
    let(:user) { create(:user, points: 1000) }

    it 'sets points to 0 and sets points expiration to 1 year from now' do
      user.expire_points
      expect(user.points).to eq(0)
      expect(user.points_expiration).to eq(1.year.from_now.to_date)
    end
  end

  describe '#update_tier' do
    let(:user) { create(:user, points: 1000) }

    it 'updates tier to gold if points reach gold level' do
      user.update_tier
      expect(user.tier).to eq('gold')
    end

    it 'updates tier to platinum if points reach platinum level' do
      user.update_points(4000)
      user.update_tier
      expect(user.tier).to eq('platinum')
    end
  end

  describe '#check_rewards_eligibility' do
    let(:user) { create(:user) }

    it 'checks rewards eligibility' do
      expect { user.check_rewards_eligibility(100) }.not_to raise_error
    end
  end

  describe '#update_monthly_points' do
    let(:user) { create(:user) }

    it 'updates monthly points and checks free coffee reward' do
      expect { user.update_monthly_points(Date.today.month) }.not_to raise_error
    end
  end
end
