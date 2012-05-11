namespace :knowl_base  do
  desc "conbine repeated keyword and it's associations"
  task :merge => :environment do
    wordNumber = 0
    #puts 'hello'
    TKeyword.all.each do |keyword|
      #puts '1'
      if !TKeyword.where(:id => keyword.id).blank? 
        TKeyword.where(:text => keyword.text, :kw_type => keyword.kw_type).each do |word|
          if word.id != keyword.id
            wordNumber+=1
            puts "#{wordNumber} : found word \"#{word.text}\" with type: \"#{word.kw_type}\", Formatted:#{word.id}, #{word.get_string}"
            TKeyword.add_to(keyword.id, word.get_string)
            #puts 'add'
            TKeyword.delete_keyword(word.id)
            #puts 'delete'
          end
        end
      end
    end
  end
end
