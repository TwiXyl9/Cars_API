require 'rails_helper'

RSpec.describe Brand, type: :model do
  it "create with correct params" do
    brand = described_class.new(name: 'Audi')
    expect(brand).to be_valid
  end
  it "create without name" do
    brand = described_class.new(name: nil)
    expect(brand).to_not be_valid
  end
  it "create without unique name" do
    FactoryBot.create(:brand, name: 'Audi')
    brand = described_class.new(name: 'Audi')
    expect(brand).to_not be_valid
    brand.errors[:name].should include("has already been taken")
  end
end
