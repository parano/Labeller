# coding: utf-8
class TKeyword < KnowlegeBase
  def self.table_name() "t_keywords" end
  validates_presence_of :text
  validates_presence_of :kw_type

  has_many :t_kw_chnls, :class_name => 'TKwChnl', :foreign_key => 'kid'
  has_many :t_channels, :through => :t_kw_chnls
  has_many :t_kw_relations, :class_name => 'TKwRelation', :foreign_key => 'kw1_id' #, :dependent => :destroy 
  has_many :re_t_kw_relations, :class_name => 'TKwRelation', :foreign_key => 'kw2_id'

  def relation_words
    words = {}
    self.t_kw_relations.each do |r|
      next if !TKeyword.exists?(r[:kw2_id])
      word = TKeyword.find(r[:kw2_id])
      type = r[:rel_type]
      if !words.has_key?(type)
        words[type] = word.text + '^' + word.kw_type
      else
        words[type] += '#' + word.text + '^' + word.kw_type
      end
    end

    if words.empty?
      return 'null'
    else
      words.keys.map{|word| word + '$' + words[word]}.join("|")
    end
  end

  def get_channels
    self.t_channels.map{|x| x.en_name}.join("|")
  end

  def get_string
    self.infos.join(", ")
  end

  def infos
    [self.text, self.kw_type, self.synonym.blank? ? 'null':self.synonym, get_channels, relation_words]
  end

  def self.data_import(data)
    if data.empty?
      return 'Nothing changed'
    else
      notice = []
      data.split("\n").map{|x| notice << TKeyword.import(x.chomp)}
    end
    notice
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
    info = formatted_keyword.split(",").map{|w| w.strip}
  end

  def self.get_keyword_by_string(formatted_keyword)
    info = TKeyword.get_infos(formatted_keyword)
    TKeyword.where(:text => info[0], :kw_type => info[1]).first
  end

  def self.get_reduplicate_word(kid, formatted_keyword)
    info = TKeyword.get_infos(formatted_keyword)
    TKeyword.where("id != ? AND text = ? AND kw_type = ?", kid, info[0], info[1]).first
  end

  def self.add_chnl_to_keyword(word, kw_type, chnl_id)
    keyword = TKeyword.where(:text => word, :kw_type => kw_type).first
    if !keyword.blank?
      ids = keyword.t_channel_ids | [chnl_id]
      keyword.t_channel_ids = ids
    end
  end

  # return true if the two relation formulas are the same to each other
  def compare_rel_kw_list(new_relation)
    new_relation == self.relation_words 
  end

  def build_kw_relation(relation)
    return true if relation.blank? || relation == "null"

    relation.split("|").each do |info|
      i = info.split('$')
      type = i[0]
      i[1].split('#').each do |word|
        text = word.split('^')[0]
        kw_type = word.split('^')[1]
        id = TKeyword.where(:text => text, :kw_type => kw_type).first.id
        self.t_kw_relations.new(:kw2_id => id, :rel_type => type)
      end
    end
    self.save
  end

  def self.delete_kw_relation(keyword_id)
    #keyword = TKeyword.find(keyword_id)
    #if keyword && !keyword.t_kw_relations.empty?
      TKwRelation.delete_all(:kw1_id => keyword_id)
      TKwRelation.delete_all(:kw2_id => keyword_id)
      #TKwRelation.where(:kw2_id => keyword_id).each { |tkwrelation| tkwrelation.destroy }
    #end
  end

  def rebuild_kw_relation(new_relation_words, original_relation_words)
    return true if new_relation_words.blank? || new_relation_words == "null"
    relations = {}
    new_relations = []

    # need some improvement later
    (new_relation_words + '|' + original_relation_words).split('|').each do |rel|
      rels = rel.split('$')
      if relations.has_key? rels[0]
        relations[rels[0]] |= rels[1].split('#') if !rels[1].blank?
      else
        relations[rels[0]] = rels[1].split('#') if !rels[1].blank?
      end
    end

    TKeyword.delete_kw_relation(self.id)
    relations.each do |key, value|
      s = value.sort.join('#')
      new_relations << (key + '$' + s)
    end

    self.build_kw_relation(new_relations.sort.join('|'))
  end

  def self.get_channel_ids(info)
    info[3].split('|').map{ |en_name| TChannel.where(:en_name => en_name).first.id }.sort
  end

  def self.update(kid, formatted_keyword)
    keyword = TKeyword.find(kid)
    kw_name = keyword.text

    if formatted_keyword.blank?
      TKeyword.delete_keyword(kid)
      return "The word : #{kw_name} was successfully deleted."  
    end

    return "Nothing changed to word #{kw_name}" if keyword.get_string == formatted_keyword

    notice = []
    info = TKeyword.get_infos(formatted_keyword)
    
    tem_word = TKeyword.get_reduplicate_word(kid, formatted_keyword)
    if !tem_word.blank?
      TKeyword.delete_keyword(kid)
      notice << "The word #{keyword.text} was combined into word #{tem_word.text}"
      notice << TKeyword.add_to(tem_word.id, formatted_keyword)
      return notice
    end

    # update keyword
    notice << "The word \"#{kw_name}\" was changed :"
    if keyword.text != info[0]
      keyword.update_attributes(:text    => info[0]) 
      notice << " the text was changed to \"#{info[0]}\", "
    end

    if keyword.kw_type != info[1]
      notice << "the Keyword Type was changed from \"#{keyword.kw_type}\" to \"#{info[1]}\", "
      keyword.update_attributes(:kw_type => info[1]) 
    end

    #if !(info[2] == 'null' || info[2].blank?)
    #  if !keyword.synonym.blank?
    #    keyword.update_attributes(:synonym => nil) 
    #    notice << "the original synonyms \"#{keyword.synonym}\" was deleted, "
    #  elsif keyword.synonym != info[2] && !keyword.synonym.blank?
    #    notice << "the synonyms was changed form \"#{keyword.synonym}\" to \"#{info[2]}\", "
    #    keyword.update_attributes(:synonym => info[2])  
    #  end
    #end
    if info[2] == 'null' && !keyword.synonym.blank?
      keyword.update_attributes(:synonym => nil)
      notice << "the original synonyms \"#{keyword.synonym}\" was deleted, "
    elsif info[2] != 'null' && keyword.synonym.blank? 
      notice << "the synonyms was changed to \"#{info[2]}\", "
      keyword.update_attributes(:synonym => info[2])  
    elsif keyword.synonym != info[2] && !keyword.synonym.blank?
      notice << "the synonyms was changed form \"#{keyword.synonym}\" to \"#{info[2]}\", "
      keyword.update_attributes(:synonym => info[2])  
    end

    # update channels
    chnl_ids = TKeyword.get_channel_ids(info) 
    if keyword.t_channel_ids.sort != chnl_ids
      old_channels = keyword.get_channels.split('|').map{|w| "\"#{w}\""}.join(',')
      keyword.t_channel_ids = chnl_ids 
      new_channels = keyword.get_channels.split('|').map{|w| "\"#{w}\""}.join(',')
      notice << "the channels was changed form #{old_channels} into #{new_channels}, "
    end

    # update relation
    if !info[4].blank? && info[4] != 'null' && !keyword.compare_rel_kw_list(info[4]) 
      if TKeyword.delete_kw_relation(keyword.id) && keyword.build_kw_relation(info[4])
        notice << "The relations of word \"#{kw_name}\" was changed into #{info[4]}."
      end
    end

    notice
  end

  def self.add_to(kid, formatted_keyword)
    notice = []
    keyword = TKeyword.find(kid)
    return "Nothing change to word #{keyword.text}" if formatted_keyword.empty? || keyword.get_string == formatted_keyword

    # update keyword
    info = TKeyword.get_infos(formatted_keyword)
    #keyword.update_attributes(:text    => info[0]) if keyword.text    != info[0]
    #keyword.update_attributes(:kw_type => info[1]) if keyword.kw_type != info[1]

    # add synonym
    if info[2] != 'null' && !info[2].empty?
      synonym = keyword.synonym
      if synonym.nil? || synonym.empty?
        keyword.update_attributes(:synonym => info[2])
        notice << "the synonyms was changed to \"#{info[2]}\""
      else
        keyword.update_attributes(:synonym => (info[2].split('|') | synonym.split('|')).join('|'))
        notice << "the synonyms was changed form \"#{keyword.synonym}\" to \"#{info[2]}\""
      end
    end

    # add channels
    chnl_ids = TKeyword.get_channel_ids(info) 
    if keyword.t_channel_ids.sort != chnl_ids
      chnl_ids = TKeyword.get_channel_ids(info) 
      chnl_ids |= keyword.t_channel_ids
      keyword.t_channel_ids = chnl_ids 
      new_channels = keyword.get_channels.split('|').map{|w| "\"#{w}\""}.join(',')
      notice << "the channels was updated into #{new_channels}"
    end

    # add relations
    if !(info[4].blank? || info[4] == 'null') && !keyword.compare_rel_kw_list(info[4])
      keyword.rebuild_kw_relation(info[4], keyword.relation_words)
    end

    notice.unshift("The word \"#{keyword.text}\" has changed: ")
    notice.join(", ")
  end

  # delete all the stuff associated with the keyword with the given id in knowlege base
  def self.delete_keyword(keyword_id)
    # t_kw_chnl
    #TKwChnl.where(:kid => keyword_id).each { |tkwchnl| tkwchnl.destroy }
    TKwChnl.delete_all(:kid => keyword_id)

    # t_kw_relation
    TKeyword.delete_kw_relation(keyword_id)

    # t_keyword
    TKeyword.find(keyword_id).destroy
  end

  def suicide
    TKeyword.delete_keyword(self.id)
  end

  def self.import(formatted_keyword)
    keyword = TKeyword.get_keyword_by_string(formatted_keyword)
    if !keyword.blank?
      notice = TKeyword.add_to(keyword.id, formatted_keyword)
    else
      notice = TKeyword.import_new_keyword(formatted_keyword)
    end
    notice
  end

  def self.import_new_keyword(formatted_keyword)
    info = TKeyword.get_infos(formatted_keyword)

    # keyword
    keyword = TKeyword.new(:text => info[0], 
                           :kw_type => info[1])
    
    # synonym
    keyword.synonym = info[2] if info[2] != "null"

    keyword.save

    # channels
    keyword.t_channel_ids = TKeyword.get_channel_ids(info)

    # relation
    keyword.build_kw_relation(info[4])

    return "Keyword #{keyword.text} formatted as \"#{keyword.get_string}\" was imported"
  end
end
