class Client < ActiveRecord::Base
  attr_accessible :cidade, :email, :nome, :telefone, :cpf, :idade, :sexo, :estado_civil, :renda_familiar
end
