class KnowlegeBaseController < ApplicationController
  def import
  end

  def review
    @keywords = TKeyword.conditions(params[:chnl], params[:kw_type], params[:key]).paginate(:page => params[:page], :per_page => 100).map!{|x| [x.id, x.get_string]}
    @channels = TChannel.all
    @kw_types = TKwType.all
  end

  def update
    @result = TKeyword.update(params[:id], params[:formatted_string])
    if @result == true 
      redirect_to :back, :notice => 'update successfully'
    else
      redirect_to :back
    end
  end

  def data_import
    params[:data].split("\n").map{|x| TKeyword.import(x.chomp)}
    redirect_to :root, :notice => 'update successfully'
  end
end
