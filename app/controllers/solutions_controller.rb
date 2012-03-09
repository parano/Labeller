class SolutionsController < ApplicationController
  def create
  	@labeltask = Labeltask.find(params[:labeltask_id])
  	@labeltask.label(params[:solution][:line_number],
  					params[:solution][:label],
  					params[:solution][:rawdata])

  	respond_to do |format|
  		format.html { redirect_to @labeltask }
  		format.js
  	end
  end

  def destroy
  	@labeltask = Labeltask.find(params[:labeltask_id])
  	@solution = Solution.find(params[:id])
  	@solution.destroy

  	respond_to do |format|
  		format.html { redirect_to @labeltask }
  		format.js
  	end
  end
end
