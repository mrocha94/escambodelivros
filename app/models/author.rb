class Author < ActiveRecord::Base
  has_many :book_authors
  has_many :books, through: :book_authors

  validates :nome, presence: true

  def to_json
    json = {}
    json[:nome] = nome
    json
  end
end
