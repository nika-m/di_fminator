
# TODO: Work on fixing the char encoding for some tracks
# I *think* it's a Windows char set thing, but still investigating.


class DiFmTrack
  attr_accessor :channel_id, :track_id, :network_id,
              :artist, :track, :title,
              :alt_artist, :alt_track,
              :duration, :started, :now_playing, :track_type,
              :votes, :art_url, :images

  Struct.new('Votes', :like, :dislike)

  def initialize(track_options)
    @channel_id = track_options.fetch('channel_id', '')
    @track_id = track_options.fetch('track_id', '')
    @network_id = track_options.fetch('network_id', '')

    @artist = track_options.fetch('artist', '')
    @title = track_options.fetch('title', '')
    @track = track_options.fetch('track', '')
    @track_type = track_options.fetch('type', '')

    # Creating/setting a display var for title/artist
    # because sometimes the artist/title info from DiFM
    # is garbled, like the char encoding was incorrect (Ex: Ñâåæàÿ Âîäà)
    # and from my observations, the 'track' data contains correct data
    @display_artist, @display_title = '', ''

    set_track_and_artist(@track)

    # Track Times
    @duration = track_options.fetch('duration', 0).to_i
    @started = track_options.fetch('started', 0).to_i

    # Misc Track Data
    @art_url = track_options.fetch('art_url', '')
    @images = track_options.fetch('images', {})
    @votes = set_votes(track_options.fetch('votes', {up: 0, down: 0}))
    @now_playing = now_playing?
  end

  def self.parse_track_list(track_list)
    track_list.map { |t| self.new(t) }
  end

  private

  def set_track_and_artist(track)
    return track if track.empty?

    @display_artist = track.split(' - ').first
    @display_title = track.split(' - ').last
  end

  def now_playing?
    now_playing = false
    track_end = @started + @duration
    current_time = Time.now.to_i

    if (track_end > current_time) && (current_time > @started)
      now_playing = true
    end

    now_playing
  end

  def set_votes(votes)
    Struct::Votes.new(votes['up'], votes['down'])
  end
end