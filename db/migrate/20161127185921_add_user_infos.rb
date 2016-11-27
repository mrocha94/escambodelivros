class AddUserInfos < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :nome, null: false
      t.string :cpf, limit: 11, null: false
      t.date :data_nascimento, null: false
      t.string :telefone, limit: 11, null: false
    end
    add_index :users, :cpf, unique: true
  end
end
