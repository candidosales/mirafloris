class HomeController < ApplicationController

	#include Sms

	def index
		 @client = Client.new
    	 respond_with @client
	end

	def test_sms
		#Zenvia.send({nome: 'Touiut', telefone: '8699335216'})
		@client = Client.new

		@client.nome = "Teste"
		@client.telefone = "8699335216"

		ClientMessage.thanks_registration(@client)

	end

end
