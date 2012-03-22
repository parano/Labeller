class Labeljob < ActiveRecord::Base
  validates :name, :presence => true,
    :length => { :maximum => 30 }
  validates :desc, :presence => true,
    :length => { :maximum => 3000 }
  validates :rawdata, :presence => true
  label_regex = /([^\|]*\|)*/
  validates :labels,  :format => { :with => label_regex }
  attr_readonly :labels,:user_ids,:rawdata


  has_many :labeltasks, :dependent => :destroy
  belongs_to :user
  # has_many :joblabellers, :dependent => :destroy
  # has_many :labellers, :through => :joblabellers,
  #                      :source => :labeller
  has_and_belongs_to_many :users
  # after_save :generate_tasks
  after_create :generate_tasks
  mount_uploader :rawdata, RawdataUploader

  def word_label?
    self.labels.blank?
  end

  def classic?
    not word_label?
  end

  def label_numbers
    self.labels.split('|').length
  end

  def generate_tasks
    # first , delete all the old tasks
    self.labeltasks.each { |task| task.destroy } if self.labeltasks !=nil

    data             = self.rawdata.read.split(/\n/).delete_if { |i| i=="" }
    length           = data.length
    labellers        = self.users
    labeller_numbers = labellers.length
    tasksize         = length / labeller_numbers
    remainder        = length % labeller_numbers

    i       = 0
    start   = 0

    while i < remainder
      self.labeltasks.create!(:status => "assigned",
                              :rawdata => data[start..(start + tasksize)].join("\n"),
                              :user_id => self.users[i].id)
      start = start + tasksize + 1
      i += 1
    end

    while i < labeller_numbers and i < length
      self.labeltasks.create!(:status => "assigned",
                              :rawdata => data[start..(start + tasksize - 1)].join("\n"),
                              :user_id => self.users[i].id)
      start = start + tasksize
      i += 1
    end
  end

  def label_all word
  end

  def delete_all word
  end
end
