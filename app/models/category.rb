class Category < ActiveRecord::Base
  belongs_to :categoria_pai
  has_many :book_categories
  has_many :books, through: :book_categories

  validates :categoria, presence: true
end
