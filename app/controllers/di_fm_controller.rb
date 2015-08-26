
class DiFmController < ApplicationController
  before_action :set_difm_manager

  def get_recent_tracks
    channel = @difm_manager.find_channel_by_id(params[:channel_id])
    render json: { channel: channel,  recent_tracks: channel.recent_tracks }
  end

  def get_channel_list
    channels = @difm_manager.channels
    render json: { channels: channels }
  end

  def get_channel
    @channel = @difm_manager.find_channel_by_id(params[:channel_id])

    render json: { channel: channel }
  end

  private

  def set_difm_manager
    @difm_manager ||= DiFmManager.new
  end

end
