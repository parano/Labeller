class SolutionsController < ApplicationController
  def label
    @labeltask = Labeltask.find(params[:labeltask_id])
    @labeljob = Labeljob.find(@labeltask.labeljob_id)
    @solution = @labeltask.solutions.find(params[:id])
    @solution.update_attributes(:label => params[:label])

    respond_to do |format|
      format.js
    end
  end
end
