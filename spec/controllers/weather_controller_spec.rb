require 'rails_helper'

RSpec.describe WeatherController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #current" do
    it "returns http success" do
      get :current
      expect(response).to have_http_status(:success)
    end
  end

end
