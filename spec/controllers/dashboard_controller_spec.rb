
require 'spec_helper'

describe DashboardController do
  describe "GET #index" do
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

  describe "GET #about" do
    it "responds successfully with HTTP 200 status code" do
      get :about
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the about template" do
      get :about
      expect(response).to render_template("about")
    end
  end

  describe "GET #resume" do
    it "responds successfully with HTTP 200 status code" do
      get :resume
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the resume template" do
      get :resume
      expect(response).to render_template("resume")
    end
  end

  describe "GET #code" do
    it "responds successfully with HTTP 200 status code" do
      get :code
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the code template" do
      get :code
      expect(response).to render_template("code")
    end
  end

  describe "GET #sandbox" do
    before do
      @tracks = create(:track)
      Track.stub(:order, created_at: :desc).and_return @tracks
    end

    it "loads all of the saved tracks into @tracks" do
      get :sandbox
      expect(assigns(:tracks)).to eq(@tracks)
    end

  end

  describe "GET #contact" do
    it "responds successfully with HTTP 200 status code" do
      get :contact
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the contact template" do
      get :contact
      expect(response).to render_template("contact")
    end
  end
end