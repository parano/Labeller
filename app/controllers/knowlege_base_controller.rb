class KnowlegeBaseController < ApplicationController
  def import
  end

  def review
    @keywords = TKeyword.conditions(params[:chnl], params[:kw_type], params[:key]).paginate(:page => params[:page], :per_page => 100).map!{|x| [x.id, x.get_string]}
    @channels = TChannel.all
    @kw_types = TKwType.all
  end

  def update
    notice = TKeyword.update(params[:id], params[:formatted_string])
    if notice.blank?
      redirect_to :back, :notice => 'update successfully'
    else
      redirect_to :back, :notice => notice.join(' ')
    end
  end

  def data_import
    notice = TKeyword.data_import(params[:data])
    if notice.blank?
      redirect_to :back, :notice => 'import successfully'
    else
      redirect_to :back, :notice => notice.join(', ')
    end
  end
end
