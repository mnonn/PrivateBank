class WowcharsController < ApplicationController
		
  	def show
    	@wowchar = Wowchar.find(params[:id])
  	end  
  
  	def new
    	@wowchar = current_user.wowchars.build
  	end

  	def edit
    	@wowchar = Wowchar.find(params[:id])
  	end

  	def create
    	@wowchar = current_user.wowchars.build(wowchar_params)
    
    	if @wowchar.save
      		redirect_to users_show_path(current_user)
    	else
      		render 'new'
    	end 
  	end

  	def update
    	@wowchar = Wowchar.find(params[:id])
    	if @wowchar.update(wowchar_params)
      		redirect_to users_show_path(current_user)
    	else 
      		render 'edit'
    	end
  	end
  
  	def destroy
  		@wowchar = Wowchar.find(params[:id])
  		@wowchar.destroy
  	  	redirect_to users_show_path(current_user)
  	end

  	private
    	def wowchar_params
      		params.require(:wowchar).permit(:name,:classname,:faction,:race,:level)
    	end
end
