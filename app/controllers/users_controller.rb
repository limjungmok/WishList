class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

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

  def guide
    
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

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "로그인 하세요"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to edit_user_path(id: current_user.id) unless @user == current_user
    end
end
