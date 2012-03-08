class Labeltask < ActiveRecord::Base
  belongs_to :labeljob
  belongs_to :user
end
