class Labeltask < ActiveRecord::Base
  belongs_to :labeljob
  belongs_to :user
  has_many :solutions, :dependent => :destroy

  def have_solution?(line_number)
  	solutions.where(:line_number => line_number).exists?
  end

  def label(line_number, label, rawdata)
  	solutions.create!(:line_number => line_number,
  						:label => label,
  						:rawdata => rawdata)
  end

  def unlabel(line_number)
  	solutions.find_by_line_number(line_number).destroy
  end

  def solution_label(line_number)
    solutions.where(:line_number => line_number).first.label
  end
end
