# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161201202227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advertisements", force: :cascade do |t|
    t.datetime "data_fim"
    t.boolean  "ativo"
    t.text     "descricao"
    t.integer  "user_id"
    t.integer  "books_group_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "titulo"
  end

  create_table "authors", force: :cascade do |t|
    t.string   "nome",            null: false
    t.string   "nacionalidade"
    t.date     "data_nascimento"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "book_authors", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_categories", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "books", force: :cascade do |t|
    t.string   "isbn",        limit: 13, null: false
    t.string   "titulo",                 null: false
    t.string   "editora",                null: false
    t.integer  "edicao",                 null: false
    t.string   "idioma",                 null: false
    t.text     "sinopse"
    t.integer  "num_paginas"
    t.integer  "ano"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "books", ["isbn"], name: "index_books_on_isbn", unique: true, using: :btree

  create_table "books_group_has_books", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "books_group_id"
    t.string   "estado"
    t.integer  "ano_compra"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "books_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "categoria",        null: false
    t.string   "descricao"
    t.integer  "categoria_pai_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "categories", ["categoria"], name: "index_categories_on_categoria", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "email",                          null: false
    t.string   "encrypted_password", limit: 128, null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128, null: false
    t.string   "nome",                           null: false
    t.string   "cpf",                limit: 11,  null: false
    t.date     "data_nascimento",                null: false
    t.string   "telefone",           limit: 11,  null: false
  end

  add_index "users", ["cpf"], name: "index_users_on_cpf", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  add_foreign_key "advertisements", "books_groups"
  add_foreign_key "advertisements", "users"
  add_foreign_key "book_authors", "authors"
  add_foreign_key "book_authors", "books"
  add_foreign_key "book_categories", "books"
  add_foreign_key "book_categories", "categories"
  add_foreign_key "books_group_has_books", "books"
  add_foreign_key "books_group_has_books", "books_groups"
  add_foreign_key "categories", "categories", column: "categoria_pai_id"
end
