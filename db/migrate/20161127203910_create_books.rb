class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :isbn, limit: 13, null: false
      t.string :titulo, null: false
      t.string :editora, null: false
      t.integer :edicao, null: false
      t.string :idioma, null: false
      t.text :sinopse
      t.integer :num_paginas
      t.integer :ano
      t.timestamps null: false
    end
    add_index :books, :isbn, unique: true
  end
end
