class Labeltask < ActiveRecord::Base
  belongs_to  :labeljob
  belongs_to  :user
  has_many    :solutions, :dependent => :destroy

  #STATUS = %w[assigned progress submit reopen approve]

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

  after_create :generate_solutions
  def generate_solutions
    self.rawdata.split(/\n/).each_with_index do |line, line_number|
      self.solutions.create!( :line_number => line_number,
                             :rawdata => line,
                             :label => "unknow")
    end
  end
end
