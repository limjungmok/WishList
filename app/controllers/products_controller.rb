class ProductsController < ApplicationController
	skip_before_filter  :verify_authenticity_token

	def index
		@user = current_user
		@user_log = @user.logs.last
		@products = @user.products.all
	end

	def new
		if logged_in?
			@user = current_user
			@product = @user.products.new
			#현재 유저가 담은, 분류되지 않은 목록들
			@current_user_products = @user.products.where(name: "")
		else
			render 'new_no_login'
		end
	end

	def create
		@user = current_user
		@product = @user.products.create(:url => params[:url])
		if @product
			redirect_to root_path(@product)
		else
			render 'new'
		end
	end

	def destroy
		@user = User.find(params[:user_id])
		@destroy_product = @user.products.find(params[:id])
		@product = @user.products.find(params[:id]).destroy

		respond_to do |format|
			format.html
			format.js
		end
	end

	def destroy_index
		@user = User.find(params[:user_id])
		@destroy_product = @user.products.find(params[:id])
		@product = @user.products.find(params[:id]).destroy

		respond_to do |format|
			format.html
			format.js
		end
	end

	def get_aj
        data = {:message => current_user.products.count}
        render :json => data, :status => :ok
    end

    def get_watting_list
        data = {:message => current_user.products.where(name: "").count}
        render :json => data, :status => :ok
    end

    def send_email
    	ExampleMailer.sample_email.deliver_now
    	redirect_to :back
    end
end
