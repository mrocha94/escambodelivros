class Advertisement < ActiveRecord::Base
  has_one :books_group
  has_many :books_group_has_books, through: :books_group
  has_many :books, through: :books_group_has_books
  belongs_to :user

  validates :ativo?, presence: true
  validates :user, presence: true
  validates :books_group, presence: true
end
