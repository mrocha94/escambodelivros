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
    sinopse: "Harry Potter has no idea how famous he is. That's because he's being raised by his miserable aunt and uncle who are terrified Harry will learn that he's really a wizard, just as his parents were. But everything changes when Harry is summoned to attend an infamous school for wizards, and he begins to discover some clues about his illustrious birthright. From the surprising way he is greeted by a lovable giant, to the unique curriculum and colorful faculty at his unusual school, Harry finds himself drawn deep inside a mystical world he never knew existed and closer to his own noble destiny.",
    author_names: ['J. K. Rowling'],
    categories_names: ["Magic", "Fantasy"]
  },
  {
    titulo: 'Harry Potter and the Chamber of Secrets',
    isbn: '0-7475-3849-2',
    editora: 'Bloomsbury Publishing',
    edicao: 1,
    idioma: 'Inglês',
    num_paginas: 327,
    ano: 1998,
    sinopse: "The Dursleys were so mean that hideous that summer that all Harry Potter wanted was to get back to the Hogwarts School for Witchcraft and Wizardry. But just as he's packing his bags, Harry receives a warning from a strange, impish creature named Dobby who says that if Harry Potter returns to Hogwarts, disaster will strike.",
    author_names: ['J. K. Rowling'],
    categories_names: ["Magic", "Fantasy"]
  },
  {
    titulo: 'Harry Potter and the Prisoner of Azkaban',
    isbn: '972-23-2601-5',
    editora: 'Bloomsbury Publishing',
    edicao: 1,
    idioma: 'Inglês',
    num_paginas: 317,
    ano: 1999,
    sinopse: "For most children, summer vacation is something to look forward to. But not for our 13-year-old hero, who's forced to spend his summers with an aunt, uncle, and cousin who detest him. The third book in J.K. Rowling's Harry Potter series catapults into action when the young wizard accidentally causes the Dursleys' dreadful visitor Aunt Marge to inflate like a monstrous balloon and drift up to the ceiling. Fearing punishment from Aunt Petunia and Uncle Vernon (and from officials at Hogwarts School of Witchcraft and Wizardry who strictly forbid students to cast spells in the nonmagic world of Muggles), Harry lunges out into the darkness with his heavy trunk and his owl Hedwig.",
    author_names: ['J. K. Rowling'],
    categories_names: ['Magic', 'Fantasy']
  },
  {
    titulo: 'The Eye of the World',
    isbn: '0-312-85009-3',
    editora: 'Tor Books',
    edicao: 1,
    idioma: 'Inglês',
    ano: 1990,
    sinopse: "When The Two Rivers is attacked by Trollocs—a savage tribe of half-men, half-beasts— five villagers flee that night into a world they barely imagined, with new dangers waiting in the shadows and in the light.",
    author_names: ['Robert Jordan'],
    categories_names: ["Epic", "Fantasy"]
  },
  {
    titulo: 'The Great Hunt',
    isbn: '0-312-85140-5',
    editora: 'Tor Books',
    edicao: 1,
    idioma: 'Inglês',
    ano: 1990,
    sinopse: "For centuries, gleemen have told the tales of The Great Hunt of the Horn. So many tales about each of th Hunters, and so many Hunters to tell of...Now the Horn itself is found: the Horn of Valere long thought only legend, the Horn which will raise the dead heroes of the ages. And it is stolen.",
    author_names: ['Robert Jordan'],
    categories_names: ["Epic", "Fantasy"]
  },
  {
    titulo: 'A Memory of Light',
    isbn: '0-312-85248-7',
    editora: 'Tor Books',
    edicao: 1,
    idioma: 'Inglês',
    ano: 2013,
    sinopse: "The Wheel of Time turns and Ages come and go, leaving memories that become legend. Legend fades to myth, and even myth is long forgotten when the Age that gave it birth returns again. In the Third Age, an Age of Prophecy, the World and Time themselves hang in the balance. What was, what will be, and what is, may yet fall under the Shadow.",
    author_names: ['Robert Jordan', 'Brandon Sanderson'],
    categories_names: ["Epic", "Fantasy"]
  }
]

authors.each do |params|
  Author.create(params)
end

books.each do |params|
  authors = params.delete(:author_names)
  categories = params.delete(:categories_names)
  book = Book.new(params)
  authors.each do |author_name|
    author = Author.where(nome: author_name)
    book.authors << author
  end
  categories.each do |cat|
    category = Category.find_by(categoria: cat)
    category ||= Category.new(categoria: cat)
    book.categories << category
  end
  book.save
end
