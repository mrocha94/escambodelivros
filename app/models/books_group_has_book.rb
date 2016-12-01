class BooksGroupHasBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :books_group

end
