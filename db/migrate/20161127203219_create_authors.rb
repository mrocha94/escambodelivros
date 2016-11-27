class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :nome, null: false
      t.string :nacionalidade
      t.date :data_nascimento

      t.timestamps null: false
    end
  end
end
