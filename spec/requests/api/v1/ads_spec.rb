require 'rails_helper'

RSpec.describe "Api::V1::Ads", type: :request do
  let!(:user){FactoryBot.create(:user, name:'Ivan', surname: 'Ivanov', phone: '+375291234567', email: 'test@mail.ru', password: 'qwerty123', role: 2) }
  let!(:brand){FactoryBot.create(:brand, name:'Audi') }
  let!(:model){FactoryBot.create(:model, name:'A4', brand: brand) }
  let!(:car){FactoryBot.create(:car, model: model, engine_capacity: 1.9, creation_year: 1996)}
  describe "for unauthorized user" do
    describe "GET /brands" do
      it "returns all ads" do
        FactoryBot.create(:ad, description: 'Test desc N1!', price: 4000, car: car, user: user)
        FactoryBot.create(:ad, description: 'Test desc N2!', price: 4500, car: car, user: user)
        get '/api/v1/ads'
        expect(response).to have_http_status(:success)
        expect(response_body.size).to eq(2)
      end
    end

    # describe "GET /brands/:id" do
    #   let!(:brand){FactoryBot.create(:brand, name:'Audi') }
    #   it "returns brand by id" do
    #     get "/api/v1/brands/#{brand.id}"
    #     expect(response).to have_http_status(:success)
    #     expect(response_body["name"]).to eq("Audi")
    #   end
    # end
    #
    # describe "POST /brands" do
    #   it "get error when create a new brand" do
    #     post '/api/v1/brands', params: {brand: {name: 'Audi'}}
    #
    #     expect(response).to have_http_status(:unauthorized)
    #   end
    # end
    #
    # describe "PATCH /brands/:id" do
    #   let!(:brand){FactoryBot.create(:brand, name:'Audi') }
    #   it "get error when update the brand" do
    #     patch "/api/v1/brands/#{brand.id}"
    #
    #     expect(response).to have_http_status(:unauthorized)
    #
    #   end
    # end
    #
    # describe "DELETE /brands/:id" do
    #   let!(:brand){FactoryBot.create(:brand, name:'Audi') }
    #   it "get error when delete the brand" do
    #     delete "/api/v1/brands/#{brand.id}"
    #
    #     expect(response).to have_http_status(:unauthorized)
    #
    #   end
    # end
  end
end