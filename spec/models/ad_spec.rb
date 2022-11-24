require 'rails_helper'

RSpec.describe Ad, type: :model do
  let!(:user){FactoryBot.create(:user, name:'Ivan', surname: 'Ivanov', phone: '+375291234567', email: 'test@mail.ru', password: 'qwerty123') }
  let!(:brand){FactoryBot.create(:brand, name:'Audi') }
  let!(:model){FactoryBot.create(:model, name:'A4', brand: brand) }
  let!(:car){FactoryBot.create(:car, model: model, engine_capacity: 1.9, creation_year: 1996)}
  it "create with full correct params" do
    ad = described_class.new(description: 'Test desc N1!', price: 4000, car: car, user: user)
    expect(ad).to be_valid
  end
  it "create without description" do
    ad = described_class.new(description: nil, price: 4000, car: car, user: user)
    expect(ad).to be_valid
  end
  it "create without price" do
    ad = described_class.new(description: 'Test desc N1!', price: nil, car: car, user: user)
    expect(ad).to_not be_valid
  end
  it "create without car" do
    ad = described_class.new(description: 'Test desc N1!', price: 4000, car: nil, user: user)
    expect(ad).to_not be_valid
  end
  it "create without user" do
    ad = described_class.new(description: 'Test desc N1!', price: 4000, car: car, user: nil)
    expect(ad).to_not be_valid
  end
end
