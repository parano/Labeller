class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
  	if current_user.nil?
      @labeltasks = Labeltask.paginate(:page => params[:page], :per_page => 50)
    else
      @labeltasks = Labeltask.where(:user_id => current_user.id )
      # @labeltasks = Labeltask.where(:user_id => current_user.id, :status => 1 )
      # @finished_tasks = Labeltask.where(:user_id => current_user.id, :status => 2 )
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @labeltasks }
    end
  end
end
