class Solution < ActiveRecord::Base
	belongs_to :labeltask

  def has_solution?
  	self.label != "unknow"
  end
end
