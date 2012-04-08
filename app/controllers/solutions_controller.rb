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

  def word_label
    @labeltask = Labeltask.find(params[:labeltask_id])
    @labeljob = Labeljob.find(@labeltask.labeljob_id)
    @solution = @labeltask.solutions.find(params[:id])

    if (!params[:label].nil? and !params[:label].blank?)
      if params[:label] == "unknown"
        @label = ["delete", @solution.label]
        @labeljob.delete_all(@solution.label) if @solution.label != "unknown"
      else
        @label = ["create", params[:label]]
        @labeljob.label_all(params[:label])
      end
    end

    respond_to do |format|
      format.js
    end
  end
end
