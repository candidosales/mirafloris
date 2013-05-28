class UserMailer < ActionMailer::Base
  default from: "mirafloristeresina@gmail.com"

  def test(email)
    mail(:to => email, :subject => "Hello World!")
  end

end
