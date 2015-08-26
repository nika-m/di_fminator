
class TracksController < ApplicationController
  before_action :authenticate_user!, :only => [:index, :show, :edit]
  before_action :set_track, only: [:show, :edit, :update, :destroy]

  RANDOM_ID_LOWER_LIMIT = 12_345
  RANDOM_ID_UPPER_LIMIT = 19_999

  def index
    @tracks = Track.order(created_at: :desc)
  end

  def show
  end

  def new
    @track = Track.new
  end

  def edit
  end

  def create
    @track = Track.new(track_params)
    request_from_sandbox = params[:sandbox_flag]

    respond_to do |format|
      if request_from_sandbox
        @track.id = rand(RANDOM_ID_LOWER_LIMIT..RANDOM_ID_UPPER_LIMIT)
        @track.created_at, @track.updated_at = Time.now, Time.now

        format.json { render json: @track, status: :created }
      else
        if @track.save
          format.html { redirect_to @track, notice: 'Track Successfully Created.' }
          format.json { render json: @track, status: :created }
        else
          format.html { render action: 'new' }
          format.json { render json: @track.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  def update
    respond_to do |format|
      if @track.update(track_params)
        format.html { redirect_to @track, notice: 'Track Successfully Updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @track.destroy
    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_track
      @track = Track.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def track_params
      params.require(:track).permit(:artist, :song, :track, :channel)
    end
end
