require 'spec_helper'

describe DiFmController do
  before do
    @channel_manager = DiFmManager.new
  end

  describe "GET #get_channel_list" do
    before do
      @channels = @channel_manager.get_channels
    end

    it "gets a list of channels from DiFm" do
      get :get_channel_list
      expect(@channels).to be_an(Array)
    end

    it "responds successfully with HTTP 200 status code" do
      get :get_channel_list
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "returns the channel list as a JSON object" do
      get :get_channel_list
      expect(JSON(response.body).has_key?("channels")).to be_true
    end
  end

  describe "GET #get_recent_tracks" do
    before do
      @channel_id = "213"
      @recent_tracks = @channel_manager.get_recent_tracks(@channel_id)
      @channel_info = @channel_manager.get_channel_info(@channel_id)
    end

    it "responds successfully with HTTP 200 status code" do
      get :get_recent_tracks
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    #it "returns the channel info and recent track list as a JSON object" do
    #  get :get_recent_tracks
    #  expect(JSON(response.body).has_key?("channel")).to be_true
    #  expect(JSON(response.body).has_key?("recent_tracks")).to be_true
    #end

  end

end