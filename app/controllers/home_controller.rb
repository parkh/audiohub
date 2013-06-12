class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@audios = current_user.audios
  end
end
