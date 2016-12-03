class Book < ActiveRecord::Base
  after_save :save_to_neo

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
    json[:sinopse] = sinopse
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

  private

  def save_to_neo
    session = DbConnection.neo4j
    query = session.query.merge(b: { Book: { id: id } })
    categories.each do |category|
      query.merge(c: { Category: { id: category.id } })
           .set_props(c: { category: category.categoria })
           .merge('(b)-[:IS]->(c)').exec
    end
    authors.each do |author|
      query.merge(a: { Author: { id: author.id } })
           .set_props(a: { name: author.nome })
           .merge('(a)-[:WRITES]->(b)').exec
    end
  end
end
