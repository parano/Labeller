#include CanCan::Ability

#def initialize(user)
#  user ||= User.new # guest user

#  if user.admin?
#    can :manage, :all
#  elsif user.initiator?
#    can :read, :all
#    can :create, Labeljob
#    can :update, Labeljob do |job|
#      job.try(:user_id) == user.id
#    end
#    can :read, task
#  else
#    can :manage, Labeltask do |task|
#      task.try(:user_id) == user.id
#    end
#    can :manage, Solution do |s|
#      Labeltask.find(s.Labeltask_id).user_id == user.id
#    end
#  end
#end
