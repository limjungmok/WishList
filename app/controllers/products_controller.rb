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
			render 'main'
		end
	end

	def create
		@user = current_user
		@product = @user.products.new(:url => params[:url])
		
		if @product.save
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
	end


	private

	def product_url_params
		params.require(:product).permit(:url)
	end
end
