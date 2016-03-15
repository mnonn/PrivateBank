class WelcomeController < ApplicationController
	#before_action :authenticate_admin!

	def index
    	@articles = Article.order("created_at DESC").page(params[:page]).per(5)
 	end
end
