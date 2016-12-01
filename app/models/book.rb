class Book < ActiveRecord::Base
  has_many :book_authors
  has_many :authors, through: :book_authors
  has_many :book_categories
  has_many :categories, through: :book_categories

  validates :isbn, isbn_format: true, uniqueness: true
  validates :titulo, presence: true
  validates :editora, presence: true
  validates :edicao, presence: true
  validates :idioma, presence: true

  def to_json
    json = {}
    json[:titulo] = titulo
    json[:editora] = editora
    json[:isbn] = isbn
    json[:edicao] = edicao
    json[:idioma] = idioma
    json[:categories] = []
    categories.each { |c| json[:categories].push c.to_json }
    json[:authors] = []
    authors.each { |a| json[:authors].push a.to_json }
    json
  end
end
