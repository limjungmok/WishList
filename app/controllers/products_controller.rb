class ProductsController < ApplicationController
	skip_before_filter  :verify_authenticity_token

	def index
		@user = current_user
		@products = @user.products.all

		@width
		@height
		@products.each do |product|
			product.avatar_remote_url = product.img
			@width = Paperclip::Geometry.from_file(Paperclip.io_adapters.for(product.avatar)).width
			@height = Paperclip::Geometry.from_file(Paperclip.io_adapters.for(product.avatar)).height
			#@width = 2
			#@height = 1
			#false = 가로가 더 큼 / #true = 세로가 더 큼

			if @width>@height
				product.w_or_h = false 
			else
				product.w_or_h = true
			end				
			product.save
		end

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
