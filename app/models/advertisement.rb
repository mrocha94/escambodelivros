class Advertisement < ActiveRecord::Base

  after_save :save_to_mongo
  belongs_to :books_group
  has_many :books_group_has_books, through: :books_group
  has_many :books, through: :books_group_has_books
  belongs_to :user

  def to_json
    json = {}
    json[:relational_id] = id
    json[:descricao] = descricao
    json[:books] = []
    books.each { |b| json[:books].push b.to_json }
    json
  end

  private

  def save_to_mongo
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
    client[:advertisement].update_one({relational_id: id}, self.to_json, {upsert: true})
  end

end
