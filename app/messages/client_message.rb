class ClientMessage 
	extend Sms

	@account = "vendepubli"
	@code = "vxzc3eYfTr"

	class << self
		def thanks_registration(client)
			@client = client
			sms({to: @client.telefone, message: "Obrigado #{@client.first_name} pelo cadastro! Acompanhe nossas novidades em mirafloris.com.br ou facebook.com/MiraflorisTeresina"})
			delivery
		end
	end
end