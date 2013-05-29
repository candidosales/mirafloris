module Sms
	class Base
			class_attribute :default_params
		    self.default_params = {
		      account: "",
		      code:    ""
		    }.freeze

		class << self
			attr_accessor :message, :response,:to

			def sms(params=[])
				@to = "55#{only_number(params[:to])}"
				@message = params[:message].to_uri
			end

			def delivery
				begin
					@response = open("http://system.human.com.br/GatewayIntegration/msgSms.do?dispatch=send&account=#{self.default_params[:account]}&code=#{self.default_params[:code]}&to=#{@to}&msg=#{@message}","r");
	
					puts "Account: #{self.default_params[:account]} / Numero: #{@to}  / Mensagem: #{@message} / Responde: #{@response}"
				rescue
					puts "Ha algum erro para o envio do SMS"
				end
			end


			def only_text(value)
				value.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').to_s
			end

			def only_number(value)
				value.gsub(/\W/,'')
			end

			def default(value = nil)
				self.default_params = default_params.merge(value).freeze if value
				default_params
			end
		end
	end
end