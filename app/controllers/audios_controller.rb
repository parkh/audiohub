class AudiosController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_audio, only: [:show, :destroy]

  def index
    if params[:friend_id]
      @audios = current_user.friends.find_by_id(params[:friend_id]).audios.all
    else
      @audios = current_user.audios.all
    end
  end

  def new
  	@audio = current_user.audios.new
  end

  def create
  	@audio = current_user.audios.new(audio_params)
    if @audio.save
      ConversionWorker.perform_async(@audio.id)
      redirect_to root_url, notice: 'Audio has been uploaded'
    else
      render action: 'new'
    end
  end

  def show
  end

  def destroy
    @audio.destroy
    redirect_to root_url, notice: 'Audio has been deleted'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audio
      @audio = current_user.audios.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def audio_params
      params.require(:audio).permit(:source)
    end
end
