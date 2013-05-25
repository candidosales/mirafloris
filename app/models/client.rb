class Client < ActiveRecord::Base
  attr_accessible :cidade, :email, :nome, :telefone, :cpf, :idade, :sexo, :estado_civil, :renda_familiar, :conjugue_nome, :conjugue_email, :conjugue_cpf, :conjugue_sexo

  validates_presence_of :nome, :email, :cpf, :cidade
  validates_uniqueness_of :cpf, :email

  validates :cpf, :cpf => true

  def first_name
  	nome = self.nome.split
    nome[0].capitalize
  end

end
