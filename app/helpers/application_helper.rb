module ApplicationHelper

  def user_email(user_id)
    return "none" if user_id.blank?
    user = User.find(user_id)
    # link_to(user.email, user_path(user))
    user.email
  end

  #[assigned progress submit reopen approve]
  def status_label label 
  	if label == "assigned"
  		raw "<span class='label'>Assigned</span>"
  	elsif label == "progress"
  		raw "<span class='label label-info'>In Progress</span>"
  	elsif label == "submit"
  		raw "<span class='label label-warning'>Submitted</span>"
  	elsif label == "reopen"
  		raw "<span class='label label-info'>Reopened and Now In Progress</span>"
  	elsif label == "approve"
  		raw "<span class='label label-success'>Approved</span>"
  	else 
  		""
  	end
  end

end
