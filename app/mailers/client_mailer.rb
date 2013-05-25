class ClientMailer < ActionMailer::Base
  default from: "mirafloris@gmail.com"

  def thanks_registration(client)
    @client = client
    @url  = "http://mirafloris.com/login"
    mail(:to => client.email, :subject => "#{client.first_name} Obrigado por comecar seu sonho!")
  end
end
