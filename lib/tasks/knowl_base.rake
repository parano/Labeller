namespace :knowl_base  do
	desc "conbine repeated keyword and it's associations"
	task :merge => :environment do
    TKeywords.each do |keyword|
      TKeyword.where(:text => keyword.text, :kw_type => keyword.kw_type).each do |word|
        if word.id != keyword.id
          TKeywords.add_to(keyword.id, word.get_string)
          TKeywords.delete_word(word.id)
        end
      end
    end
  end
end
