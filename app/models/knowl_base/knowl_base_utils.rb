# coing: utf-8
# = =
module KnowlBaseUtils
  def db_client
    return Mysql2::Client.new(:host => Settings.knowl_base.host,
                              :username => Settings.knowl_base.username,
                              :password => Settings.knowl_base.password,
                              :database => Settings.database)
    #return Mysql2::Client.new(ActiveRecord::Base.configurations["knowlege_base"][::Rails.env])
  end

  def get_channels
    #channels = []
    #db_client.query("SELECT cn_name FROM t_channel").each{|x| channels << x['cn_name']}
    #channels
    TChannel.select(:cn_name).map {|r| r.cn_name}
  end

  def get_kw_types
    kw_types = {}
    db_client.query("SELECT * FROM t_kw_type").each do |type|
      kw_types[type['label']] = type['desc'] 
    end
    kw_types
  end

  def get_chnl_id_by_cn_name(mysql_client, chnl_cn_name)
    mysql_client.query("SELECT id FROM t_channel WHERE cn_name='#{chnl_cn_name}'").first["id"]
  end

  def get_words(chnl_cn_name, kw_type)
    words = []
    client = db_client
    chnl_id = get_chnl_id_by_cn_name(client, chnl_cn_name)
    client.query("SELECT TEXT FROM t_keywords AS tk JOIN t_kw_chnl AS wkc ON tk.id = wkc.kid WHERE chnl_id = #{chnl_id} AND kw_type = '#{kw_type}'").each { |word| words << word["TEXT"].chomp.strip }
    words
  end

  def get_conflicts(chnl_cn_name, kw_type)
    conflicts = self.exportation.split("\n").map{|x| x.chomp.strip} & get_words(chnl_cn_name, kw_type) 
    self.update_attributes( :conflicts => conflicts.join("\n"),
                            :chnl_name => chnl_cn_name,
                            :kw_type => kw_type)
    conflicts
  end

  def export_to_knowlbase
    client = db_client
    chnl_id = get_chnl_id_by_cn_name(client, self.chnl_name)
    export = self.get_unconflict_words
    export.each do |word|
      keyword = TKeyword.where(:text => word, :kw_type => self.kw_type)
      if keyword.blank?
        insert_word_to_knowlbase(client, word, chnl_id, self.kw_type)
        #notice = TKeyword.import_new_keyword(formatted_keyword)
      end
    and
    return true
  end

  def insert_word_to_knowlbase(client, word, chnl_id, kw_type)
    client.query("INSERT INTO t_keywords (text, kw_type) VALUES ('#{word}','#{kw_type}')")
    kid = client.last_id
    client.query("INSERT INTO t_kw_chnl (kid, chnl_id) VALUES (#{kid}, '#{chnl_id}')")
  end
end
