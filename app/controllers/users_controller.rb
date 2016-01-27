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
    if(User.find_by(:login_id => params[:user][:login_id]))
      flash.now[:danger] = "아이디가 존재합니다"
    else
      flash.now[:danger] = "비밀번호 오류"
    end
		render 'new'
	end
  end

  def login
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash.now[:success] = "회원정보 수정 완료"
      redirect_to root_path
    else
      flash.now[:danger] = "비밀번호 오류"
      render 'edit'
    end
  end
  private

  	def user_params
  		params.require(:user).permit(:login_id, :password, :password_confirmation)
  	end

end
