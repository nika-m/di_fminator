require 'open-uri'
require 'di_fm_track'

class DiFmChannel
  attr_reader :name, :url, :id

  AUDIO_ADDICT_URL = YAML.load_file("#{Rails.root}/config/di_fm.yaml")['endpoints']['audio_addict']

  def initialize(channel_options)
    @name = channel_options.fetch(:name, '')
    @url = channel_options.fetch(:url, '')
    @id = channel_options.fetch(:id, '')
  end

  def recent_tracks
    audio_addict_data = open(AUDIO_ADDICT_URL.gsub('0000', @id)).read
    raw_track_list = JSON.parse(audio_addict_data[audio_addict_data.index('(') + 1..-3])
    track_list = DiFmTrack.parse_track_list(raw_track_list)

    # Filter out any advertisements
    track_list.find_all { |t| t.track_type.eql?('track') }
  end

end