class ProductsController < ApplicationController
	skip_before_filter  :verify_authenticity_token

	

	def new
		if logged_in?
			@user = current_user
			@product = @user.products.new
			#현재 유저가 담은, 분류되지 않은 목록들
			@current_user_products = @user.products.where(name: "")
			@products = @user.products.all
			@products_date = @user.products.all.sort_by(&:price).reverse
		else
			render 'new_no_login'
		end
	end

	def create
		@user = current_user
		@product = @user.products.create(:url => params[:url], :user_info => @user.login_id)

		if @product
			redirect_to root_path(@product)
		else
			render 'new'
		end
		# 내칭구 왤캐 열심히하냥ㅎ
	end

	def update
 		@user = current_user
 		@product = @user.products.find(params[:id])
 		@product.name = params[:name]
 		if params[:price] != nil
 			@product.price = params[:price]
 			@product.url = params[:url]
 			@product.img = params[:img]
 		end
 		@product.save
 	end

 	def update_for_extention
 		@user = User.find_by(id: params[:user_id])
 		@product = @user.products.find(params[:id])
 		@product.name = params[:name]
 		if params[:price] != nil
 			@product.price = params[:price]
 			@product.url = params[:url]
 			@product.img = params[:img]
 		end
 		@product.save
 	end

	def destroy
		@user = User.find(params[:user_id])
		@destroy_product = @user.products.find(params[:id])
		@product = @user.products.find(params[:id]).destroy

		respond_to do |format|
			format.js
		end
	end

	def get_product_count
		data = {:message => current_user.products.count, :watting => current_user.products.where(name: "").count}
		render :json => data, :status => :ok
	end

	def get_product_last_product
		last_product = current_user.products.last
		data = {:id => last_product.id, :created_at => last_product.created_at.strftime("%Y-%m-%d")}
		render :json => data, :status => :ok
	end

	def get_product_last_product_for_extention
		user = User.find_by(id: params[:id])
		last_product = user.products.last
		data = {:id => last_product.id, :created_at => last_product.created_at.strftime("%Y-%m-%d")}
		render :json => data, :status => :ok
	end

	def get_user_id_for_extention
		user_id = User.find_by login:params[:user_id]
		user_id = user_id.id
		data = {:user_id => user_id}
		render :json => data, :status => :ok
	end

	def send_email
		ExampleMailer.sample_email.deliver_now
		redirect_to :back
	end

	def send_email_for_extention
		ExampleMailer.sample_email.deliver_now
		redirect_to "/"
	end

	def get_unclassify_list
		data = {:list => current_user.products.where(name: "")}
		render :json => data, :status => :ok
	end

	def extention_login
		user = User.find_by(login_id: params[:id])

		data = {:message => "success"}
		data_ = {:message => "fail"}


		if user && user.authenticate(params[:pw])

			data = {:message => "success", :user_id => user.id}
			respond_to do |format|
				format.html
				format.js
				format.json { render :json => data}
			end
			
		else
			respond_to do |format|
				format.html
				format.js
				format.json { render :json => data_}
			end
		end
	end

	def extention_add
		@user = User.find_by(login_id: params[:id])
		@user.products.create(:url => params[:url])

	end

end
