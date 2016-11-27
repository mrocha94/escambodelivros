# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

authors = [
  {
    nome: 'J. K. Rowling',
    nacionalidade: 'Inglaterra',
    data_nascimento: Date.new(1965, 7, 31)
  },
  {
    nome: 'Robert Jordan',
    nacionalidade: 'Estados Unidos',
    data_nascimento: Date.new(1948, 10, 17)
  },
  {
    nome: 'Brandon Sanderson',
    nacionalidade: 'Estados Unidos',
    data_nascimento: Date.new(1975, 12, 19)
  }
]

books = [
  {
    titulo: 'Harry Potter and the Philosopher\'s Stone',
    isbn: '0-7475-3269-9',
    editora: 'Bloomsbury Publishing',
    edicao: 1,
    idioma: 'Inglês',
    num_paginas: 223,
    ano: 1997,
    author_names: ['J. K. Rowling']
  },
  {
    titulo: 'Harry Potter and the Chamber of Secrets',
    isbn: '0-7475-3849-2',
    editora: 'Bloomsbury Publishing',
    edicao: 1,
    idioma: 'Inglês',
    num_paginas: 327,
    ano: 1998,
    author_names: ['J. K. Rowling']
  },
  {
    titulo: 'Harry Potter and the Prisoner of Azkaban',
    isbn: '972-23-2601-5',
    editora: 'Bloomsbury Publishing',
    edicao: 1,
    idioma: 'Inglês',
    num_paginas: 317,
    ano: 1999,
    author_names: ['J. K. Rowling']
  },
  {
    titulo: 'The Eye of the World',
    isbn: '0-312-85009-3',
    editora: 'Tor Books',
    edicao: 1,
    idioma: 'Inglês',
    ano: 1990,
    author_names: ['Robert Jordan']
  },
  {
    titulo: 'The Great Hunt',
    isbn: '0-312-85140-5',
    editora: 'Tor Books',
    edicao: 1,
    idioma: 'Inglês',
    ano: 1990,
    author_names: ['Robert Jordan']
  },
  {
    titulo: 'A Memory of Light',
    isbn: '0-312-85248-7',
    editora: 'Tor Books',
    edicao: 1,
    idioma: 'Inglês',
    ano: 2013,
    author_names: ['Robert Jordan', 'Brandon Sanderson']
  }
]

authors.each do |params|
  Author.create(params)
end

books.each do |params|
  authors = params.delete(:author_names)
  book = Book.new(params)
  authors.each do |author_name|
    author = Author.where(nome: author_name)
    book.authors << author
  end
  book.save
end
