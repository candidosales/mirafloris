class ClientMessage < Sms::Base
	default account: "vendepubli", code: "vxzc3eYfTr"

	def self.thanks_registration(client)
		@client = client
		sms({to: @client.telefone, message: "#{@client.first_name} Obrigado por comecar seu futuro! Acompanhe seu futuro em mirafloris.com.br ou facebook.com/MiraflorisTeresina"})
		delivery
	end
end