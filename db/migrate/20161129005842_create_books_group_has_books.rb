class CreateBooksGroupHasBooks < ActiveRecord::Migration
  def change
    create_table :books_group_has_books do |t|
      t.references :book
      t.references :books_group
      t.string :estado
      t.integer :ano_compra
      t.timestamps null: false
    end
    add_foreign_key :books_group_has_books, :books
    add_foreign_key :books_group_has_books, :books_groups
  end
end
