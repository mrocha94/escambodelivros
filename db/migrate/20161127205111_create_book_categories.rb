class CreateBookCategories < ActiveRecord::Migration
  def change
    create_table :book_categories do |t|
      t.references :book
      t.references :category
      t.timestamps null: false
    end
    add_foreign_key :book_categories, :books
    add_foreign_key :book_categories, :categories
  end
end
