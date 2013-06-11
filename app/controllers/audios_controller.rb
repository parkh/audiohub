class AudiosController < ApplicationController
  before_action :set_audio, only: [:show, :destroy]

  def index
  	@audios = Audio.all
  end

  def new
  	@audio = Audio.new
  end

  def create
  	@audio = Audio.new(audio_params)
    if @audio.save
      ConversionWorker.perform_async(@audio.id)
      redirect_to audios_url, notice: 'Audio has been uploaded'
    else
      render action: 'new'
    end
  end

  def show
  end

  def destroy
    @audio.destroy
    redirect_to audios_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audio
      @audio = Audio.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def audio_params
      params.require(:audio).permit(:source)
    end
end
