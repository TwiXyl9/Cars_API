require 'rails_helper'

RSpec.describe Model, type: :model do
  let!(:brand){FactoryBot.create(:brand, name: 'Audi')}
  it "create with correct params" do
    model = described_class.new(name: 'A4', brand: brand)
    expect(model).to be_valid
  end
  it "create without name" do
    model = described_class.new(name: nil)
    expect(model).to_not be_valid
  end
  it "create without brand" do
    model = described_class.new(name: "A4")
    expect(model).to_not be_valid
  end
  it "create without unique name" do
    FactoryBot.create(:model, name: 'A4', brand: brand)
    model = described_class.new(name: 'A4')
    expect(model).to_not be_valid
    model.errors[:name].should include("has already been taken")
  end
end
