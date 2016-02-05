class SessionsController < ApplicationController
    skip_before_filter :verify_authenticity_token, :only => :create

  def new
  end

  def create
  	user = User.find_by(login_id: params[:login_id].downcase)
  	if user && user.authenticate(params[:password])
  		log_in user
      redirect_to root_path
  	else
	    flash[:danger] = 'Invalid email/password combination' # Not quite right!
  		render 'new'
  	end
  end

  def destroy
  	
  end

  def destroy
    # current_user_log = current_user.logs.last
    # current_user_log.logout_time = Time.now
    # current_user_log.save
    log_out
    redirect_to root_url
  end

end
