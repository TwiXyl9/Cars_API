require 'rails_helper'

RSpec.describe Api::V1::ModelsController, type: :request do
  let!(:brand){FactoryBot.create(:brand, name:'Audi') }
  let!(:model){FactoryBot.create(:model, name:'A4', brand: brand) }
  describe "for unauthorized user" do
    describe "GET /models" do
      it "returns all models" do
        FactoryBot.create(:model, name: 'A6', brand: brand)
        get "/api/v1/brands/#{brand.id}/models"
        expect(response).to have_http_status(:success)
        expect(response_body.size).to eq(2)
      end
    end

    describe "GET /models/:id" do
      it "returns model by id" do
        get "/api/v1/brands/#{brand.id}/models/#{model.id}"
        expect(response).to have_http_status(:success)
        expect(response_body["name"]).to eq("A4")
      end
    end

    describe "POST /models" do
      it "get error when create a new model" do
        post "/api/v1/brands/#{brand.id}/models", params: {model: {name: 'Audi'}, brand: brand}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "PATCH /models/:id" do
      it "get error when update the model" do
        patch "/api/v1/brands/#{brand.id}/models/#{model.id}"

        expect(response).to have_http_status(:unauthorized)

      end
    end

    describe "DELETE /models/:id" do
      it "get error when delete the model" do
        delete "/api/v1/brands/#{brand.id}/models/#{model.id}"

        expect(response).to have_http_status(:unauthorized)

      end
    end
  end
  describe "for authorized user " do
    describe "with moderator role" do
      before(:each) do
        @current_user = FactoryBot.create(:user, name:'Ivan', surname: 'Ivanov', phone: '+375291234567', email: 'test@mail.ru', password: 'qwerty123', role: 2)
        login(@current_user.email, @current_user.password)
        @auth_params = get_auth_params_from_login_response_headers(response)
      end
      describe "GET /models" do
        it "returns all models" do
          FactoryBot.create(:model, name: 'A6', brand: brand)
          get "/api/v1/brands/#{brand.id}/models"
          expect(response).to have_http_status(:success)
          expect(response_body.size).to eq(2)
        end
      end

      describe "GET /models/:id" do
        it "returns model by id" do
          get "/api/v1/brands/#{brand.id}/models/#{model.id}"
          expect(response).to have_http_status(:success)
          expect(response_body["name"]).to eq("A4")
        end
      end

      describe "POST /models" do
        it "create a new model" do
          expect{
            post "/api/v1/brands/#{brand.id}/models", params: {model: {name: 'A6', brand_id: brand.id}}, headers: @auth_params
          }.to change {Model.count}.from(1).to(2)

          expect(response).to have_http_status(:created)
          expect(response_body["name"]).to eq("A6")
        end
      end

      describe "PATCH /models/:id" do
        it "update the model" do
          patch "/api/v1/brands/#{brand.id}/models/#{model.id}", params: {model: {name: 'A6'}}, headers: @auth_params

          expect(response).to have_http_status(:success)
          expect(response_body["name"]).to eq("A6")
        end
      end

      describe "DELETE /models/:id" do
        it "delete a model" do
          expect{
            delete "/api/v1/brands/#{brand.id}/models/#{model.id}", headers: @auth_params
          }.to change {Model.count}.from(1).to(0)

          expect(response).to have_http_status(:no_content)
        end
      end

      describe "create model with incorrect params" do

        describe "POST /models" do
          it "get error" do
            post "/api/v1/brands/#{brand.id}/models", params: {model: {name: '', brand_id: brand.id}}, headers: @auth_params

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                                          "name" => ["can't be blank"]
                                        })
          end
        end
      end

      describe "update model with incorrect params" do
        describe "PATCH /models/:id" do
          it "get error" do
            patch "/api/v1/brands/#{brand.id}/models/#{model.id}", params: {model: {name: ''}}, headers: @auth_params

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
        login(@current_user.email, @current_user.password)
        @auth_params = get_auth_params_from_login_response_headers(response)
      end
      describe "POST /models" do
        it "create a new model" do
          expect{
            post "/api/v1/brands/#{brand.id}/models", params: {model: {name: 'A6'}}, headers: @auth_params
          }.to raise_error(Errors::LackAccessRights)
        end
      end

      describe "PATCH /models/:id" do
        it "update the model" do
          expect{
            patch "/api/v1/brands/#{brand.id}/models/#{model.id}", params: {model: {name: 'A6'}}, headers: @auth_params
          }.to raise_error(Errors::LackAccessRights)
        end
      end

      describe "DELETE /models/:id" do
        it "delete a model" do
          expect{
            delete "/api/v1/brands/#{brand.id}/models/#{model.id}", headers: @auth_params
          }.to raise_error(Errors::LackAccessRights)

        end
      end
    end
  end

end
