class LabeljobsController < ApplicationController
  # GET /labeljobs
  # GET /labeljobs.json
  def index
    @labeljobs = Labeljob.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @labeljobs }
    end
  end

  # GET /labeljobs/1
  # GET /labeljobs/1.json
  def show
    @labeljob = Labeljob.find(params[:id])

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
end
