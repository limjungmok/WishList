class ProductsController < ApplicationController
	skip_before_filter  :verify_authenticity_token

	def index
		@user = current_user
		@products = @user.products.all
	end

	def new
		if logged_in?
			@user = current_user
			@product = @user.products.new
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

	def edit
	end

	def update
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
end
