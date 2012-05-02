class TKwRelation < KnowlegeBase
  def 
    self.table_name() "t_kw_relation" 
  end


  validates_presence_of :rel_type
  validates_presence_of :kw1_id
  validates_presence_of :kw2_id

  has_one :keyword, :class_name => 'TKeyword', :foreign_key => 'kw1_id'
end
