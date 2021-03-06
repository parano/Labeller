class Labeljob < ActiveRecord::Base
  include KnowlBaseUtils

  validates :name, :presence => true,
    :length => { :maximum => 30 }
  validates :desc, :presence => true,
    :length => { :maximum => 3000 }
  label_regex = /([^\|]*\|)*/
  validates :labels,  :format => { :with => label_regex }
  attr_readonly :labels,:user_ids,:rawdata

  has_many :labeltasks, :dependent => :destroy
  belongs_to :user
  has_and_belongs_to_many :users
  after_create :generate_tasks
  mount_uploader :rawdata, RawdataUploader
  mount_uploader :filter, FilterUploader

  def fun
    array = []
    array.each { |element| body }
  end

  def word_label?
    self.labels.blank?
  end

  def classic?
    not word_label?
  end

  def finished?
    self.finished 
  end

  def exportation_array
    earray = []
    if self.word_label?
      self.labeltasks.each do |tasks|
        earray |= tasks.solutions.where("label != 'unknown'").select(:label).uniq.all.map { |t| t.label.strip }
      end
      #earray.uniq
    else
      self.labeltasks.each do |tasks|
        earray += tasks.solutions.where("label != 'unknown'").select('label, rawdata').all.map do |solution|
          solution.rawdata.strip + "\t" + solution.label   
        end
      end
    end
    earray.sort
  end
  
  def get_exportation
    if !self.exportation.blank? 
      return self.exportation
    else
      exportation = self.exportation_array.join("\n")
      self.update_attributes(:exportation => exportation)  
    end
  end

  def delete_exportation
    self.update_attributes(:exportation => '')
  end

  def get_unconflict_words
    self.exportation.split("\n").map{|x| x.chomp} - self.conflicts.split("\n").map{|x| x.chomp}
  end
    
  def finish!
    self.update_attributes(:finished => true)
    self.labeltasks.each do |task|
      task.approve!
    end
    self.save!
  end

  def generate_tasks
    # first , delete all the old tasks
    self.labeltasks.each { |task| task.destroy } if self.labeltasks !=nil
    data = self.rawdata.read.split(/\n/).delete_if { |i| i == "" }

    if self.word_label? && !self.filter.url.nil?
      #filtrate the rawdata
      self.filter.read.split(/\n/).delete_if { |i| i == "" }.each do |filter|
        data.delete_if { |item| item.include?(filter) }
      end
    end

    length           = data.length
    labellers        = self.users
    labeller_numbers = labellers.length
    tasksize         = length / labeller_numbers
    remainder        = length % labeller_numbers

    i       = 0
    start   = 0

    while i < remainder
      create_task(i, start, tasksize, data) 
      start = start + tasksize + 1
      i += 1
    end

    while i < labeller_numbers && i < length
      create_task(i, start, tasksize, data) 
      start = start + tasksize
      i += 1
    end
  end

  def create_task(i, start, tasksize, data)
    self.labeltasks.create!(:status => "assigned",
                            :user_id => self.users[i].id)
    labeltask = self.labeltasks.where(:user_id => self.users[i].id).first

    data[start..(start + tasksize - 1)].each_with_index do |line, line_number|
      labeltask.solutions.create!(:line_number => line_number,
                                  :rawdata => line,
                                  :label => "unknown")
    end   
  end

  def label_all(word)
    self.labeltasks.each do |task|
      task.solutions.where("label = 'unknown' AND rawdata LIKE '%#{word}%'").update_all "label = '#{word}'"
    end
  end

  def delete_all(word)
    self.labeltasks.each do |task|
      task.solutions.where(:label => word).update_all(:label => "unknown")
    end
  end
end
