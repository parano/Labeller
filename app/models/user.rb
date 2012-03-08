class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role, :email, :password, :password_confirmation, :remember_me

  has_many :labeljobs
  has_many :labeltasks

  ROLES = %w[admin initator labeller]

  def role_symbols
  	[role.to_sym]
  end

  def admin?
    self.role == "admin"
  end

  def initator?
    self.role == "initator"
  end

  def labeller?
    self.role == "labeller"
  end

  scope :labellers, where(:role => "labeller")

end
