class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model 
  #  
  attr_accessible  :role, :email, :password, :password_confirmation, :remember_me

  has_many :labeljobs
  has_many :labeltasks

  has_and_belongs_to_many :jobs, :class_name => "Labeljob"

  # has_many :joblabellers
  # has_many :jobs, :through => :joblabellers, :source => :labeljob

  ROLES = %w[admin initiator labeller]

  def role_symbols
  	[role.to_sym]
  end

  def admin?
    self.role == "admin"
  end

  def initiator?
    self.role == "initiator"
  end

  def labeller?
    self.role == "labeller"
  end

  scope :labellers, where(:role => "labeller")

  before_save :default_values
  def default_values
    self.role ||= 'labeller'
  end

end
