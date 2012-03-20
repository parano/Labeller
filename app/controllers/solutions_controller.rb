class SolutionsController < ApplicationController
  def label
    @labeltask = Labeltask.find(params[:labeltask_id])
    @labeljob = Labeljob.find(@labeltask.labeljob_id)
    @solution = @labeltask.solutions.find(params[:id])
    @solutions = @labeltask.solutions
    if (!params[:label].nil? and !params[:label].blank?)
      @solution.update_attributes(:label => params[:label])
    end

    respond_to do |format|
      format.js
    end
  end
end
