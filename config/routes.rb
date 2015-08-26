DiFminator::Application.routes.draw do
  match '/di/channels/list' => 'di_fm#get_channel_list', :via => :get, :as => :di_channels
  match '/di/channels/:channel_id/tracks' => 'di_fm#get_recent_tracks', :via => :get
  match '/di/tracks' => 'tracks#index', :via => :get, :as => :saved_tracks
  match '/di/tracks/save' => 'tracks#create', :via => :post

  root 'dashboard#sandbox'
end
