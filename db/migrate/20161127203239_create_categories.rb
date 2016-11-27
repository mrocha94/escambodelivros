class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :categoria, null: false
      t.string :descricao
      t.references :categoria_pai
      t.timestamps null: false
    end
    add_foreign_key :categories, :categories, column: :categoria_pai_id
    add_index :categories, :categoria, unique: true
  end
end
