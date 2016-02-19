class OyrAdminController < ApplicationController

	def index
		if !logged_in?
			redirect_to root_path
		elsif current_user.login_id == "admin"
		
			@add_things = Product.where(name: '')

			@add_things.each do |f|
				f.url
			end
		else
			redirect_to root_path
		end
	end

	def update
		@add_things = Product.find(params.require(:product).permit(:id)[:id])
		@add_things.update(product_params)
		redirect_to :back
	end

	def check_admin
		if current_user.login_id != "admin"
			redirect_to "/"	
		end
	end

	private

	def product_params
		params.require(:product).permit(:id, :price, :name, :img)
	end
end