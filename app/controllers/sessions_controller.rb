class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(login_id: params[:session][:login_id].downcase)
  	if user && user.authenticate(params[:session][:password])
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
    log_out
    redirect_to root_url
  end

end