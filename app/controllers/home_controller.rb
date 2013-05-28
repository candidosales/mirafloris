class HomeController < ApplicationController

	include Sms

	def index
		 @client = Client.new
    	 respond_with @client
	end

	def test_sms
		Zenvia.send({nome: 'Test', telefone: '8699335216'})
	end

end
