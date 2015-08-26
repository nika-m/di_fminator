require 'spec_helper'

describe TracksController do

  def valid_attributes
    return {:artist => "Sveta", :song => "Your Eyes", :track => "Sveta - Your Eyes",
            :channel => "Russian Club Hits"}
  end

  describe "GET index" do
    before do
      @user = create(:user)
      sign_in(@user)

      @tracks = create(:track)
      Track.stub(:order, created_at: :desc).and_return @tracks
    end

    it "assigns all tracks as @tracks" do
      get :index
      assigns(:tracks).should eq(@tracks)
    end

    it "responds successfully with HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end