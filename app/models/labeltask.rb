class Labeltask < ActiveRecord::Base
  belongs_to  :labeljob
  belongs_to  :user
  has_many    :solutions, :dependent => :destroy

  #STATUS = %w[assigned progress submit reopen approve]
  
  def submit!
    self.update_attributes(:status => "submit")
    self.submit_time = Time.now
    self.save!
  end

  def not_editable?
    self.status == "submit" || self.status == "approve"
  end

  def editable?(user)
    (self.status != "submit" && self.status != "approve") &&
      (self.user_id == user.id || !user.labeller?)
  end

  def submitable?
    self.status != "approve" && self.status != "submit"
  end

  def submit?
    self.status == "submit"
  end

  def approve!
    self.update_attributes(:status => "approve")
    self.save!
  end

  before_save :default_values
  def default_values
    self.label_count = 0
    self.unlabel_count = 0
  end

  def inc_label_count!
    Labeltask.increment_counter(:label_count, self.id)
  end

  def inc_unlabel_count!
    Labeltask.increment_counter(:unlabel_count, self.id)
  end

  #def rawdata=(rawdata)
  #  self.rawdata.each_with_index do |line, line_number|
  #    self.solutions.create!( :line_number => line_number,
  #                            :rawdata => line,
  #                            :label => "unknown")
  #  end
  #end

  #def rawdata
  #  self.solutions.map { |x| x.rawdata }.join("\n")
  #end

  #after_create :generate_solutions
  #def generate_solutions
  #  self.rawdata.split(/\n/).each_with_index do |line, line_number|
  #    self.solutions.create!( :line_number => line_number,
  #                           :rawdata => line,
  #                           :label => "unknown")
  #  end
  #end
end
