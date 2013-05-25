module SMS
	class Zenvia
		def initializer
			@account = "vendepubli"
			@code = 'vxzc3eYfTr'
		end
		
		def send(params)
			to = "55#{params[:telefone].gsub(/\W/,'')}"
			msg = "Obrigado #{params[:nome]} pelo cadastro. Acompanhe nossas novidades pelo facebook.com/MiraflorisTeresina e mirafloris.com.br".to_uri
			begin
				response = File.open("http://system.human.com.br/GatewayIntegration/msgSms.do?dispatch=send&account=#{@account}&code=#{@code}&to=#{to}&msg=#{msg}","r");
			rescue
				puts "Há algum erro para o envio do SMS"
				exit
			end
			
		end

		def only_number(number)
		 	number.gsub(/\W/,'') 
		end

	end
end