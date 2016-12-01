class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.datetime :data_fim
      t.boolean :ativo, default: false
      t.text :descricao
      t.references :user
      t.references :books_group
      t.timestamps null: false
    end
    add_foreign_key :advertisements, :books_groups
    add_foreign_key :advertisements, :users
  end
end
