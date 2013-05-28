module Sms
	class Zenvia
		attr_accessor :account, :code

		@account = "vendepubli"
		@code = "vxzc3eYfTr"

		def self.send(params=[])
			numero = params[:telefone].gsub(/\W/,'')
			nome = params[:nome].mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').to_s
			to = "55#{numero}"
			msg = "Obrigado #{nome} pelo cadastro. Acompanhe nossas novidades pelo facebook.com/MiraflorisTeresina e mirafloris.com.br".to_uri
			
			puts "#{nome} : Nome / #{numero} : Numero / #{msg} : Mensagem"

			begin
				response = open("http://system.human.com.br/GatewayIntegration/msgSms.do?dispatch=send&account=#{@account}&code=#{@code}&to=#{to}&msg=#{msg}","r");
			rescue
				puts "Ha algum erro para o envio do SMS"
			end

		end
	end
end