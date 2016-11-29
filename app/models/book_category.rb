class BookCategory < ActiveRecord::Base
  belongs_to :book
  belongs_to :category

  validates :book, presence: true
  validates :category, presence: true
end
