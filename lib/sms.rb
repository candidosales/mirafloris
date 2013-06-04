require 'open-uri'

module Sms

	attr_accessor :message, :response,:to, :account, :code

	def sms(params=[])
		@to = "55#{only_number(params[:to])}"
		@message = params[:message].to_uri
	end

	def delivery
		begin
			@response = open("http://system.human.com.br/GatewayIntegration/msgSms.do?dispatch=send&account=#{@account}&code=#{@code}&to=#{@to}&msg=#{@message}","r");

			puts "Account: #{@account} / Numero: #{@to}  / Mensagem: #{@message} / Responde: #{@response}"
		rescue
			puts "Account: #{@account} / Numero: #{@to}  / Mensagem: #{@message} / Responde: #{@response}"
			puts "Ha algum erro para o envio do SMS"
		end
	end


	def only_text(value)
		value.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').to_s
	end

	def only_number(value)
		value.gsub(/\W/,'')
	end

end