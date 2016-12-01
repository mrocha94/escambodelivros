class BooksGroup < ActiveRecord::Base
  has_many :books_group_has_book
  has_many :books, through: :books_group_has_book
  has_one :advertisement
end
