require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User authentication' do
    it 'is database authenticable with correct params' do
      user = FactoryBot.create(:user, name:'Ivan', surname: 'Ivanov', phone: '+375291234567', email: 'test@mail.ru', password: 'qwerty123')
      expect(user.valid_password?(user.password)).to be_truthy
    end
    it 'is database authenticable with incorrect params' do
      user = FactoryBot.create(:user, name:'Ivan', surname: 'Ivanov', phone: '+375291234567', email: 'test@mail.ru')
      expect(user.valid_password?('qwerty1234')).to be_falsey
    end
  end

  it 'user email validation with correct data' do

  end
end
