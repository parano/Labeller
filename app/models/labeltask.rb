class Labeltask < ActiveRecord::Base
  belongs_to  :labeljob
  belongs_to  :user
  has_many    :solutions, :dependent => :destroy

  STATUS = %w[assigned progress submit reopen approve]

  def not_editable? 
    self.status == "submit" or self.status == "approve"
  end

  def editable?(user) 
    (self.status != "submit" and self.status != "approve") and 
    (self.user_id == user.id || !user.labeller?)
  end

  def submitable?
    self.status != "approve" and self.status != "submit"
  end

  def submit?
    self.status == "submit"
  end

  # def has_solution?(line_number)
  # 	solutions.where(:line_number => line_number).first.label != "unknow"
  # end

  # def label(line_number, label)
  # 	solutions.find_by_line_number(line_number).update_attributes!(:label => label)
  # end

  # def unlabel(line_number)
  # 	solutions.find_by_line_number(line_number).update_attributes!(:label => "unknow")
  # end

  # def solution_label(line_number)
  #   solutions.where(:line_number => line_number).first.label 
  # end

  after_create :generate_solutions
  def generate_solutions
    self.rawdata.split(/\n/).each_with_index do |line, line_number| 
        self.solutions.create!( :line_number => line_number,
                                :rawdata => line,
                                :label => "unknow")
    end  
  end
end
