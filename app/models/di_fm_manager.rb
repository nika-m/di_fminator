
require 'nokogiri'
require 'open-uri'
require 'di_fm_channel'

class DiFmManager
  include ApplicationHelper

  attr_accessor :channels
  attr_reader :config

  CHANNEL_CACHE_KEY = 'difm_channel_list'
  TRACK_LIST_CACHE_KEY = 'difm_track_list'
  DEFAULT_CACHE_TIME = 86_400
  DI_APP_INFO_NODE = 64

  def initialize
    @config = YAML.load_file("#{Rails.root}/config/di_fm.yaml") || (raise 'DiFM config file missing!')
    @channels = load_channels
  end

  def refresh_channel_list
    Rails.logger.info 'Manually Refreshing Channel List'

    kill_cache(CHANNEL_CACHE_KEY)
    @channels = load_channels
  end

  def find_channel_by_id(channel_id)
    channels = load_channels

    channels.each do |c|
      return c if c.id.eql?(channel_id)
    end
  end

  private

  def load_channels
    # TODO: If list is empty, don't cache for 24hrs
    data_cache(CHANNEL_CACHE_KEY, DEFAULT_CACHE_TIME) do
      channels_list
    end
  end

  def channels_list
    channels = []

    # TODO: Refactor and clean up
    channel_node = Nokogiri::HTML(open(@config['endpoints']['di_fm']['channels'])).css('script')[DI_APP_INFO_NODE]
    node_string = channel_node.to_s.gsub("<script>\n  di.app.start(", '').gsub(");\n</script>", '')
    channel_list = JSON.parse(node_string)['channels']

    channel_list.each do |channel|
      channel_attributes = {
        name: channel.fetch('name', ''),
        url: channel.fetch('url', ''),
        key: channel.fetch('key', ''),
        id: channel.fetch('id', '').to_s
      }
      channels << DiFmChannel.new(channel_attributes)
    end

    channels.sort { |a,b| a.name <=> b.name }
  end
end

