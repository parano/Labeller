class TChannel < KnowlegeBase
  def self.table_name() "t_channel" end
  has_many :t_kw_chnls, :class_name => 'TKwChnl', :foreign_key => 'chnl_id'
  has_many :t_keywords, :through => :t_kw_chnls

  #def self.en_names
  #  TChannel.all.map{|x| x[:en_name]}
  #end
end
