class TKeyword < KnowlegeBase
  def self.table_name() "t_keywords" end
  validates_presence_of :text
  validates_presence_of :kw_type

  has_many :t_kw_chnls, :class_name => 'TKwChnl', :foreign_key => 'kid'
  has_many :t_channels, :through => :t_kw_chnls
  has_many :t_kw_relations, :class_name => 'TKwRelation', :foreign_key => 'kw1_id'

  def relation_words
    words = {}
    self.t_kw_relations.each do |r|
      word = TKeyword.find(r[:kw2_id])
      type = r[:rel_type]
      if !words.has_key?(type)
        words[type] = word.text + '^' + word.kw_type
      else
        words[type] += '#' + word.text + '^' + word.kw_type
      end
    end
    words.keys.map{|word| word + '$' + words[word]}.join("|")
  end

  def get_channels
    self.t_channels.map{|x| x.en_name}.join("|")
  end

  def get_string
    self.infos.join("\t")
  end

  def infos
    [self.text, self.kw_type, self.synonym.blank? ? 'null':self.synonym, get_channels, relation_words]
  end

  def self.conditions(chnl_id, kw_type, key)
    return TKeyword.where(:kw_type => 'B') if chnl_id.nil? || kw_type.nil? || key.nil?

    condition = {}
    if !chnl_id.empty?
      ids = TChannel.find(chnl_id).t_keyword_ids
      condition.merge!({:id => ids})
    end
    condition.merge!({:kw_type => kw_type}) if !kw_type.empty?

    if key.empty?
      if condition.empty?
        return TKeyword.where(:kw_type => 'B')
      else
        return TKeyword.where(condition)
      end
    else
      if condition.empty?
        return TKeyword.where("text LIKE '%#{key}%'")
      else
        return TKeyword.where("text LIKE '%#{key}%'").where(condition)
      end
    end
  end

  def self.get_infos(formatted_keyword)
    info = formatted_keyword.split("\t")
    info[3] = '' if info[3] == 'null'
    info
  end

  def self.get_keyword_id_by_string(formatted_keyword)
    info = TKeyword.get_infos(formatted_keyword)
    TKeyword.where(:text => info[0], :kw_type => info[1]).first
  end

  # return true if the two relation formulas are the same to each other
  def compare_rel_kw_list(old_relation)

  end

  def build_kw_relation(relation)

  end

  def self.get_channel_ids(info)
    info[3].split('|').map{ |en_name| TChannel.where(:en_name => en_name).first.id }.sort
  end

  def self.update(kid, formatted_keyword)
    return delete(kid) if formatted_keyword.empty?

    # update keyword
    keyword = TKeyword.find(kid)
    info = TKeyword.get_infos(formatted_keyword)
    keyword.update_attributes(:text    => info[0]) if keyword.text    != info[0]
    keyword.update_attributes(:kw_type => info[1]) if keyword.kw_type != info[1]
    keyword.update_attributes(:synonym => info[2]) if keyword.synonym != info[2] || keyword.synonym.blank?

    # update channels
    chnl_ids = TKeyword.get_channel_ids(info) 
    keyword.t_channel_ids = chnl_ids if keyword.t_channel_ids.sort != chnl_ids

    # update relation
    if keyword.compare_rel_kw_list(info[4])
      keyword.delete_kw_relation
      keyword.build_kw_relation(info[4])
    end
  end

  # delete all the stuff associated with the keyword with the given id in knowlege base
  def delete(keyword_id)
    # t_kw_chnl
    TKwChnl.where(:kid => keyword_id).each { |tkwchnl| tkwchnl.destroy }

    # t_kw_relation
    delete_kw_relation(keyword_id)

    # t_keyword
    TKeyword.find(keyword_id).destroy
  end

  def suicide
    delete(self.id)
  end

  def delete_kw_relation(keyword_id)
    TKwRelation.where(:kw1_id => keyword_id).each { |tkwrelation| tkwrelation.destroy }
    TKwRelation.where(:kw2_id => keyword_id).each { |tkwrelation| tkwrelation.destroy }
  end

  def self.import(formatted_keyword)
    keyword = TKeyword.get_keyword_id_by_string(formatted_keyword)
    if !keyword.blank?
      TKeyword.update(keyword.id, formatted_keyword)
    else
      TKeyword.insert(formatted_keyword)
    end
  end

  def self.insert(formatted_keyword)
    info = TKeyword.get_infos(formatted_keyword)

    # keyword
    keyword = TKeyword.new(:text => info[0], 
                           :kw_type => info[1], 
                           :synonym => info[2])
    keyword.save
    
    # channels
    keyword.t_channel_ids = TKeyword.get_channel_ids(info)

    # relation
    keyword.build_kw_relation(keyword, info[4])
  end
end
