class HomeController < ApplicationController

	def index
		 @client = Client.new
    	 respond_with @client
	end

end
