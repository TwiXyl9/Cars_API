require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "Brands API", type: :request do
  describe "Brands for unauthorized user" do
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
        expect(response_body).to eq ({
          "errors" => ["You need to sign in or sign up before continuing."]
        })
      end
    end

    describe "PATCH /brands/:id" do
      let!(:brand){FactoryBot.create(:brand, name:'Audi') }
      it "get error when update the brand" do
        patch "/api/v1/brands/#{brand.id}"

        expect(response).to have_http_status(:unauthorized)
        expect(response_body).to eq ({
          "errors" => ["You need to sign in or sign up before continuing."]
        })
      end
    end

    describe "DELETE /brands/:id" do
      let!(:brand){FactoryBot.create(:brand, name:'Audi') }
      it "get error when delete the brand" do
        delete "/api/v1/brands/#{brand.id}"

        expect(response).to have_http_status(:unauthorized)
        expect(response_body).to eq ({
          "errors" => ["You need to sign in or sign up before continuing."]
        })
      end
    end
  end
  describe "Brands for authorized user" do
    before(:each) do
      @current_user = FactoryBot.create(:user, name:'Ivan', surname: 'Ivanov', phone: '+375291234567', email: 'test@mail.ru', password: 'qwerty123')
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

  end
  def login
    post '/authentication/sign_in', params:  { email: @current_user.email, password: @current_user.password }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def get_auth_params_from_login_response_headers(response)
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token-type' => token_type
    }
    auth_params
  end
end
