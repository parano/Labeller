class Labeljob < ActiveRecord::Base
	validates :name, :presence => true,
					 :length => { :maximum => 30 }
	validates :desc, :presence => true
	label_regex = /([^\|]*\|)+/
	validates :labels,  :format => { :with => label_regex }
	has_many :labeltasks

    mount_uploader :rawdata, RawdataUploader

    def generate_tasks
    	
    end

end
