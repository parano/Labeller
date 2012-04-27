class KnowlegeBase < ActiveRecord::Base
  self.abstract_class = true
  #use_connection_ninja(:knowlege_base)
  establish_connection configurations["knowlege_base"][::Rails.env]
end
