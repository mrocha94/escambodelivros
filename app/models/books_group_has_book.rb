class BooksGroupHasBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :books_group

  validates :book, presence: true
  validates :books_group, presence: true
end
