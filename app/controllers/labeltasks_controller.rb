class LabeltasksController < ApplicationController
  before_filter :authenticate_user!

  # GET labeljobs/1/labeltasks/1
  # GET labeljobs/1/labeltasks/1.json
  def show
    @labeljob = Labeljob.find(params[:labeljob_id]) if params[:labeljob_id]
    @labeltask = Labeltask.find(params[:id])
    @owner = User.find(@labeltask.user_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @labeltask }
    end
  end
end
