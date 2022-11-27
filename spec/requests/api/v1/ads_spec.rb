require 'rails_helper'

RSpec.describe "Api::V1::Ads", type: :request do
  let!(:user){FactoryBot.create(:user, name:'Ivan', surname: 'Ivanov', phone: '+375291234567', email: 'test@mail.ru', password: 'qwerty123') }
  let!(:brand){FactoryBot.create(:brand, name:'Audi') }
  let!(:model){FactoryBot.create(:model, name:'A4', brand: brand) }
  let!(:car){FactoryBot.create(:car, model: model, engine_capacity: 1.9, creation_year: 1996)}
  describe "for unauthorized user" do
    describe "GET /ads" do
      it "returns all ads" do
        FactoryBot.create(:ad, description: 'Test desc N1!', price: 4000, car: car, user: user)
        FactoryBot.create(:ad, description: 'Test desc N2!', price: 4500, car: car, user: user)
        get '/api/v1/ads'
        expect(response).to have_http_status(:success)
        expect(response_body.size).to eq(2)
        expect(response_body[0]["price"]).to eq(4000)
        expect(response_body[1]["price"]).to eq(4500)
      end
    end

    describe "GET /ads/:id" do
      let!(:ad){FactoryBot.create(:ad, description: 'Test desc N1!', price: 4000, car: car, user: user) }
      it "returns ad by id" do
        get "/api/v1/ads/#{ad.id}"
        expect(response).to have_http_status(:success)
        expect(response_body["description"]).to eq("Test desc N1!")
      end
    end

    describe "POST /ads" do
      it "get error when create a new ad" do
        post '/api/v1/ads', params: {car: {engine_capacity: 2.4, creation_year: 1996, model_id: 1}, ad: {price: 6000, description: "Green candy", user_id: 1}}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "PATCH /ads/:id" do
      let!(:ad){FactoryBot.create(:ad, description: 'Test desc N1!', price: 4000, car: car, user: user) }
      it "get error when update the ad" do
        patch "/api/v1/ads/#{ad.id}"

        expect(response).to have_http_status(:unauthorized)

      end
    end

    describe "DELETE /ads/:id" do
      let!(:ad){FactoryBot.create(:ad, description: 'Test desc N1!', price: 4000, car: car, user: user) }
      it "get error when delete the ad" do
        delete "/api/v1/ads/#{ad.id}"

        expect(response).to have_http_status(:unauthorized)

      end
    end
  end
  describe "for authorized user " do
    before(:each) do
      login(user.email, user.password)
      @auth_params = get_auth_params_from_login_response_headers(response)
    end
    describe "with correct params" do
      describe "POST /ads" do
        it "create a new ad with existing сar" do
          photo = fixture_file_upload('spec/files/img_1.jpg', 'image/png')
          expect{
            post '/api/v1/ads', params: {car: {engine_capacity: car.engine_capacity, creation_year: car.creation_year, model_id: model.id}, ad: {price: 6000, description: "Test desc!", user_id: user.id, photos: [photo]}}, headers: @auth_params
          }.to change {Ad.count}.from(0).to(1)
          expect(response).to have_http_status(:created)
          expect(response_body["description"]).to eq("Test desc!")
        end
        it "create a new ad with new сar" do
          expect{
            post '/api/v1/ads', params: {car: {engine_capacity: 2.0, creation_year: 1999, model_id: model.id}, ad: {price: 6000, description: "Test desc!", user_id: user.id}}, headers: @auth_params
          }.to change {Ad.count}.from(0).to(1)
          expect(response).to have_http_status(:created)
          expect(response_body["description"]).to eq("Test desc!")
        end
      end
      describe "PATCH /ads/:id" do
        let!(:ad){FactoryBot.create(:ad, description: 'Test desc N1!', price: 4000, car: car, user: user) }
        it "update the ad" do
          patch "/api/v1/ads/#{ad.id}", params: {car: {engine_capacity: car.engine_capacity, creation_year: car.creation_year, model_id: model.id}, ad: {price: 6000, description: "Patch success!", user_id: user.id}}, headers: @auth_params
          expect(response).to have_http_status(:success)
          expect(response_body["description"]).to eq("Patch success!")
        end
      end

      describe "DELETE /ads/:id" do
        let!(:ad){FactoryBot.create(:ad, description: 'Test desc N1!', price: 4000, car: car, user: user) }
        it "delete the ad" do
          expect{
            delete "/api/v1/ads/#{ad.id}", headers: @auth_params
          }.to change {Ad.count}.from(1).to(0)

          expect(response).to have_http_status(:no_content)
        end
      end
    end
    describe "with incorrect params" do
      describe "new сar without engine_capacity" do
        describe "POST /ads" do
          it "get error" do

            post '/api/v1/ads', params: {car: {engine_capacity: '', creation_year: 1999, model_id: model.id}, ad: {price: 6000, description: "Test desc!", user_id: user.id}}, headers: @auth_params

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                                          "engine_capacity" => ["can't be blank"]
                                        })
          end
        end
        describe "PATCH /ads/:id" do
          let!(:ad){FactoryBot.create(:ad, description: 'Test desc N1!', price: 4000, car: car, user: user) }
          it "get error" do

            patch "/api/v1/ads/#{ad.id}", params: {car: {engine_capacity: '', creation_year: 1999, model_id: model.id}, ad: {price: 6000, description: "Test desc!", user_id: user.id}}, headers: @auth_params

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                                          "engine_capacity" => ["can't be blank"]
                                        })
          end
        end

      end
      describe "new ad without price" do
        let!(:ad){FactoryBot.create(:ad, description: 'Test desc N1!', price: 4000, car: car, user: user) }
        describe "for new ad" do
          describe "POST /ads" do
            it "get error" do

              post '/api/v1/ads', params: {car: {engine_capacity: 2.0, creation_year: 1999, model_id: model.id}, ad: {price: '', description: "Test desc!", user_id: user.id}}, headers: @auth_params

              expect(response).to have_http_status(:unprocessable_entity)
              expect(response_body).to eq({
                                            "price" => ["can't be blank"]
                                          })
            end
          end
          describe "PATCH /ads/:id" do
            it "get error" do

              patch "/api/v1/ads/#{ad.id}", params: {car: {engine_capacity: 2.0, creation_year: 1999, model_id: model.id}, ad: {price: '', description: "Test desc!", user_id: user.id}}, headers: @auth_params

              expect(response).to have_http_status(:unprocessable_entity)
              expect(response_body).to eq({
                                            "price" => ["can't be blank"]
                                          })
            end
          end
        end
      end
      describe "DELETE /ads/:id" do
        describe "with wrong id" do
          let!(:ad){FactoryBot.create(:ad, description: 'Test desc N1!', price: 4000, car: car, user: user) }
          it "get error" do
            delete "/api/v1/ads/#{ad.id + 1}", headers: @auth_params

            expect(response).to have_http_status(:not_found)
            expect(response_body["errors"]).to eq("Couldn't find Ad with 'id'=#{ad.id+1}")
          end
        end
      end
    end
  end
end