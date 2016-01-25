class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
	@user = User.new(user_params)	
	if @user.save
	    flash.now[:success] = "회원가입 성공"
	    log_in @user
		redirect_to root_path
	else
		render 'new'
	end
  end

  def login
  end

  private

  	def user_params
  		params.require(:user).permit(:login_id, :password, :password_confirmation)
  	end
end
