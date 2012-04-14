class TKwChnl < KnowlegeBase
  def self.table_name() "t_kw_chnl" end
  validates_presence_of :kid
  validates_presence_of :chnl_id

  belongs_to :t_keyword, :class_name => 'TKeyword', :foreign_key => 'kid'
  belongs_to :t_channel, :class_name => 'TChannel', :foreign_key => 'chnl_id'
end
