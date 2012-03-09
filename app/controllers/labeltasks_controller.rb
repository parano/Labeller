class LabeltasksController < ApplicationController
  before_filter :authenticate_user!

  # GET labeljobs/1/labeltasks/1
  # GET labeljobs/1/labeltasks/1.json
  def show
    @labeltask = Labeltask.find(params[:id])
    @labeljob = Labeljob.find(@labeltask.labeljob_id)
    @owner = User.find(@labeltask.user_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @labeltask }
    end
  end

  def finish
    @labeltask = Labeltask.find(params[:id])
    @labeltask.update_attributes(:status => 2)


    if @labeltask.save
      redirect_to @labeltask, notice: 'Label task finished'
    else
      render action: "show", notice: 'fininshed Denied'
    end
  end

  def unfinish
    @labeltask = Labeltask.find(params[:id])
    @labeltask.update_attributes(:status => 1)

    if @labeltask.save
      redirect_to root_url, notice: 'Label changed to unfinished'
    else
      render action: "show", notice: 'Access Denied'
    end
  end

  def label
    
  end

  def unlabel
  end

end
