class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@audios = current_user.audios.all
  	@friends = current_user.friends & current_user.inverse_friends
  end
end
