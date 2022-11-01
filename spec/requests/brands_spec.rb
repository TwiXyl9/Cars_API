require 'rails_helper'

RSpec.describe Api::V1::BrandsController, type: :request do
  describe "for unauthorized user" do
    describe "GET /brands" do
      it "returns all brands" do
        FactoryBot.create(:brand, name: 'Audi')
        FactoryBot.create(:brand, name: 'Nissan')
        get '/api/v1/brands'
        expect(response).to have_http_status(:success)
        expect(response_body.size).to eq(2)
      end
    end

    describe "GET /brands/:id" do
      let!(:brand){FactoryBot.create(:brand, name:'Audi') }
      it "returns brand by id" do
        get "/api/v1/brands/#{brand.id}"
        expect(response).to have_http_status(:success)
        expect(response_body["name"]).to eq("Audi")
      end
    end

    describe "POST /brands" do
      it "get error when create a new brand" do
        post '/api/v1/brands', params: {brand: {name: 'Audi'}}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "PATCH /brands/:id" do
      let!(:brand){FactoryBot.create(:brand, name:'Audi') }
      it "get error when update the brand" do
        patch "/api/v1/brands/#{brand.id}"

        expect(response).to have_http_status(:unauthorized)

      end
    end

    describe "DELETE /brands/:id" do
      let!(:brand){FactoryBot.create(:brand, name:'Audi') }
      it "get error when delete the brand" do
        delete "/api/v1/brands/#{brand.id}"

        expect(response).to have_http_status(:unauthorized)

      end
    end
  end
  describe "for authorized user " do
    describe "with moderator role" do
      before(:each) do
        @current_user = FactoryBot.create(:user, name:'Ivan', surname: 'Ivanov', phone: '+375291234567', email: 'test@mail.ru', password: 'qwerty123', role: 2)
        login
        @auth_params = get_auth_params_from_login_response_headers(response)
      end
      describe "GET /brands" do
        it "returns all brands" do
          FactoryBot.create(:brand, name: 'Audi')
          FactoryBot.create(:brand, name: 'Nissan')
          get '/api/v1/brands'
          expect(response).to have_http_status(:success)
          expect(response_body.size).to eq(2)
        end
      end

      describe "GET /brands/:id" do
        let!(:brand){FactoryBot.create(:brand, name:'Audi') }
        it "returns brand by id" do
          get "/api/v1/brands/#{brand.id}"
          expect(response).to have_http_status(:success)
          expect(response_body["name"]).to eq("Audi")
        end
      end
      describe "POST /brands" do
        it "create a new brand" do
          expect{
            post '/api/v1/brands', params: {brand: {name: 'Audi'}}, headers: @auth_params
          }.to change {Brand.count}.from(0).to(1)

          expect(response).to have_http_status(:created)
          expect(response_body["name"]).to eq("Audi")
        end
      end

      describe "PATCH /brands/:id" do
        let!(:brand){FactoryBot.create(:brand, name:'Audi') }
        it "update the brand" do
          patch "/api/v1/brands/#{brand.id}", params: {brand: {name: 'Nissan'}}, headers: @auth_params

          expect(response).to have_http_status(:success)
          expect(response_body["name"]).to eq("Nissan")
        end
      end

      describe "DELETE /brands/:id" do
        let!(:brand){FactoryBot.create(:brand, name:'Audi') }
        it "delete a brand" do
          expect{
            delete "/api/v1/brands/#{brand.id}", headers: @auth_params
          }.to change {Brand.count}.from(1).to(0)

          expect(response).to have_http_status(:no_content)
        end
      end
      describe "create brand with incorrect params" do
        describe "POST /brands" do
          it "get error" do
            post '/api/v1/brands', params: {brand: {name: ''}}, headers: @auth_params

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                                          "name" => ["can't be blank"]
                                        })
          end
        end
      end
      describe "update brand with incorrect params" do
        describe "PATCH /brands/:id" do
          let!(:brand){FactoryBot.create(:brand, name:'Audi') }
          it "get error" do
            patch "/api/v1/brands/#{brand.id}", params: {brand: {name: ''}}, headers: @auth_params

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                                          "name" => ["can't be blank"]
                                        })
          end
        end
      end
    end
    describe "without role" do
      before(:each) do
        @current_user = FactoryBot.create(:user, name:'Ivan', surname: 'Ivanov', phone: '+375291234567', email: 'test@mail.ru', password: 'qwerty123')
        login
        @auth_params = get_auth_params_from_login_response_headers(response)
      end
      describe "POST /brands" do
        it "create a new brand" do
          expect{
            post '/api/v1/brands', params: {brand: {name: 'Audi'}}, headers: @auth_params
          }.to raise_error(Errors::LackAccessRights)
        end
      end

      describe "PATCH /brands/:id" do
        let!(:brand){FactoryBot.create(:brand, name:'Audi') }
        it "update the brand" do
          expect{
            patch "/api/v1/brands/#{brand.id}", params: {brand: {name: 'Nissan'}}, headers: @auth_params
          }.to raise_error(Errors::LackAccessRights)
        end
      end

      describe "DELETE /brands/:id" do
        let!(:brand){FactoryBot.create(:brand, name:'Audi') }
        it "delete a brand" do
          expect{
            delete "/api/v1/brands/#{brand.id}", headers: @auth_params
          }.to raise_error(Errors::LackAccessRights)

        end
      end
    end
  end

end
