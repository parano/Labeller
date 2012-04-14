class LabeljobsController < ApplicationController
  before_filter :authenticate_user!

  # GET /labeljobs
  # GET /labeljobs.json
  def index
    if current_user.nil?
      @labeljobs = Labeljob.all
    else
      @labeljobs = Labeljob.where(:user_id => current_user.id, :finished => false)
      @finishedjobs = Labeljob.where(:user_id => current_user.id, :finished => true)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @labeljobs }
    end
  end

  # GET /labeljobs/1
  # GET /labeljobs/1.json
  def show
    @labeljob = Labeljob.find(params[:id])
    @author = User.find(current_user.id)
    @labeltasks = @labeljob.labeltasks
    @approve_count = @labeltasks.where(:status => "approve").count
    @submit_count = @labeltasks.where(:status => "submit").count

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @labeljob }
    end
  end

  # GET /labeljobs/new
  # GET /labeljobs/new.json
  def new
    @labeljob = Labeljob.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @labeljob }
    end
  end

  # GET /labeljobs/1/edit
  def edit
    @labeljob = Labeljob.find(params[:id])
  end

  # POST /labeljobs
  # POST /labeljobs.json
  def create
    @labeljob = Labeljob.new(params[:labeljob])
    @labeljob.user_id = current_user.id if current_user != nil

    if params[:labeljob][:rawdata].blank?
      @labeljob.errors[:rawdata] = 'rawdata can\'t be blank'
      render action: "new"
    else
      respond_to do |format|
        if @labeljob.save
          format.html { redirect_to @labeljob, notice: 'Labeljob was successfully created.' }
          format.json { render json: @labeljob, status: :created, location: @labeljob }
        else
          format.html { render action: "new" }
          format.json { render json: @labeljob.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /labeljobs/1
  # PUT /labeljobs/1.json
  def update
    @labeljob = Labeljob.find(params[:id])

    respond_to do |format|
      if @labeljob.update_attributes(params[:labeljob])
        format.html { redirect_to @labeljob, notice: 'Labeljob was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @labeljob.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labeljobs/1
  # DELETE /labeljobs/1.json
  def destroy
    @labeljob = Labeljob.find(params[:id])
    @labeljob.destroy

    respond_to do |format|
      format.html { redirect_to labeljobs_url }
      format.json { head :no_content }
    end
  end

  # GET /labeljobs/1/finish
  def finish
    @labeljob = Labeljob.find(params[:id])
    @labeljob.finish!
    #@labeljob.get_exportation

    if @labeljob.save
      redirect_to @labeljob, notice: 'Label job was successfully finished'
    else
      render action: "show", notice: 'Finish Denied'
    end
  end

  # GET /labeljobs/1/reopen
  def reopen
    @labeljob = Labeljob.find(params[:id])
    @labeljob.update_attributes(:finished => false)
    @labeljob.delete_exportation

    if @labeljob.save
      redirect_to @labeljob, notice: 'Labeljob was successfully UNDO finished'
    else
      render action: "show", notice: 'UNDO Denied'
    end
  end

  def review
    @labeljob = Labeljob.find(params[:id])
    @exportation = @labeljob.get_exportation
  end

  def download_export
    @labeljob = Labeljob.find(params[:id])
    send_data @labeljob.exportation, :filename => @labeljob.name + '.txt'
  end

  def choose
    @labeljob = Labeljob.find(params[:id])
    @channels = @labeljob.get_channels.map{|x| x="<option>" + x + "</option>"}.join
    @kw_types = @labeljob.get_kw_types.keys.map{|x| x="<option>" + x + "</option>"}.join
  end

  def export
    @labeljob = Labeljob.find(params[:id])
    if !params[:chnl].blank? and !params[:kw_type].blank?
      @conflicts = @labeljob.get_conflicts(params[:chnl], params[:kw_type])
      @unconflict = @labeljob.get_unconflict_words
      @export_number = @unconflict.count
    else
      redirect_to :back, :notice => 'Choose chnl and tw_type !!!'
    end
  end

  def export_to_knowl_base
    @labeljob = Labeljob.find(params[:id])
    if @labeljob.export_to_knowlbase
      redirect_to @labeljob, notice: 'Labeljob was successfully exported to knowl-base!'
    else
      redirect_to :back, :notice => 'export fails'
    end
  end
end
