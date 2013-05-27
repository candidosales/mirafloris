module Admin
	module ClientsHelper
		def renda_familiar(value)
			case value
			when "3"
				"Ate 3 salarios "
			when "3-6"
				"De 3 a 6 salarios "
			else
				"+ 6 salarios"
			end
		end
	end
end
