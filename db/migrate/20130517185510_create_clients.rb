class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :nome
      t.string :cpf
      t.string :email
      t.string :cidade
      t.string :telefone
      t.string :idade
  	  t.string :sexo
  	  t.string :estado_civil
  	  t.string :renda_familiar
  	  t.string :conjugue_nome
      t.string :conjugue_email
  	  t.string :conjugue_sexo
  	  t.string :conjugue_cpf

      t.timestamps
    end
  end
end
