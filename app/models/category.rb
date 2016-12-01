class Category < ActiveRecord::Base
  belongs_to :categoria_pai
  has_many :book_categories
  has_many :books, through: :book_categories

  validates :categoria, presence: true

  def to_json
    json = {}
    json[:categoria] = categoria
    json
  end
end
