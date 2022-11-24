require 'rails_helper'

RSpec.describe Car, type: :model do
  let!(:brand){FactoryBot.create(:brand, name:'Audi') }
  let!(:model){FactoryBot.create(:model, name:'A4', brand: brand) }
  it "create with full correct params" do
    car = described_class.new(model: model, engine_capacity: 1.9, creation_year: 1996)
    expect(car).to be_valid
  end
  it "create without model" do
    car = described_class.new(model: nil, engine_capacity: 1.9, creation_year: 1996)
    expect(car).to_not be_valid
  end
  it "create without engine_capacity" do
    car = described_class.new(model: model, engine_capacity: nil, creation_year: 1996)
    expect(car).to_not be_valid
  end
  it "create without creation_year" do
    car = described_class.new(model: model, engine_capacity: 1.9, creation_year: nil)
    expect(car).to_not be_valid
  end
end
