class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @labeltasks = Labeltask.where(:user_id => current_user.id).where("status != 'approve'")
    @approved_tasks =  Labeltask.where(:user_id => current_user.id, :status => "approve")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @labeltasks }
    end
  end
end
