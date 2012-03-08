module ApplicationHelper
	def user_email(user_id)
	    return "none" if user_id.blank?
	    user = User.find(user_id)
	    # link_to(user.email, user_path(user))
	    user.email
  	end
end
