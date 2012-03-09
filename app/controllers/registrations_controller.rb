# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
	http_basic_authenticate_with :name => "labeller", :password => "labeller", :only => [:create, :new]

  def new
    super
  end

  def create
    # add custom create logic here
    super
  end

end 