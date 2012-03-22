class LabeltasksController < ApplicationController
  before_filter :authenticate_user!

  # GET labeljobs/1/labeltasks/1
  # GET labeljobs/1/labeltasks/1.json
  def show
    @labeltask = Labeltask.find(params[:id])
    @labeljob = Labeljob.find(@labeltask.labeljob_id)
    @solutions = @labeltask.solutions.paginate(:page => params[:page], :per_page => 100)
    @owner = User.find(@labeltask.user_id)
    @labels = @labeljob.labels.split('|')
    @finished_solution = @solutions.delete_if{ |item| item.label == 'unknow'}
    @unfinished_solution = @solutions.delete_if{ |item| item.label != 'unknow'}

    if @labeltask.status == "assigned" and current_user == @owner
      @labeltask.update_attributes(:status => "progress")
      @labeltask.save
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @labeltask }
    end
  end

  def submit
    @labeltask = Labeltask.find(params[:id])
    @labeljob = Labeljob.find(@labeltask.labeljob_id)
    @solutions = @labeltask.solutions.paginate(:page => params[:page], :per_page => 100)
    @owner = User.find(@labeltask.user_id)
    @labels = @labeljob.labels.split('|')
    
    @labeltask.update_attributes(:status => "submit")

    if @labeltask.save
      redirect_to @labeltask, notice: 'Label task was submitted'
    else
      render action: "show", notice: 'Submit Denied'
    end
  end

  def undo_submit
    @labeltask = Labeltask.find(params[:id])
    @labeljob = Labeljob.find(@labeltask.labeljob_id)
    @solutions = @labeltask.solutions.paginate(:page => params[:page], :per_page => 100)
    @owner = User.find(@labeltask.user_id)
    @labels = @labeljob.labels.split('|')
    
    @labeltask.update_attributes(:status => "progress")

    if @labeltask.save
      redirect_to @labeltask, notice: 'Label task was now in progress'
    else
      render action: "show", notice: 'Submit Denied'
    end
  end

  def approve
    @labeltask = Labeltask.find(params[:id])
    @labeljob = Labeljob.find(@labeltask.labeljob_id)
    @solutions = @labeltask.solutions.paginate(:page => params[:page], :per_page => 100)
    @owner = User.find(@labeltask.user_id)
    @labels = @labeljob.labels.split('|')

    if  @labeltask.status == "submit" and @labeltask.update_attributes(:status => "approve") and @labeltask.save
      redirect_to @labeltask, notice: 'Label task was approved'
    else
      render action: "show", notice: 'Approve Denied'
    end
  end

  def reopen
    @labeltask = Labeltask.find(params[:id])
    @labeltask.update_attributes(:status => "reopen")
    @labeljob = Labeljob.find(@labeltask.labeljob_id)

    if @labeltask.save
      redirect_to @labeltask, notice: 'Label task was reopend'
    else
      render action: "show", notice: 'Reopen Denied'
    end
  end

end
