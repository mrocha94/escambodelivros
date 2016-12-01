class Advertisement < ActiveRecord::Base

  after_save :save_to_mongo
  belongs_to :books_group
  has_many :books_group_has_books, through: :books_group
  has_many :books, through: :books_group_has_books
  belongs_to :user

  validate :ativo?

  def to_json
    json = {}
    json[:relational_id] = id
    json[:descricao] = descricao
    json[:updated_at] = updated_at
    json[:books] = []
    books.each { |b| json[:books].push b.to_json }
    json
  end

  private

  def ativo?
    errors.add(:ativo, 'needs at least one book') if ativo && books.size.zero?
  end

  def save_to_mongo
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
    if ativo
      client[:advertisement].update_one({relational_id: id}, self.to_json, {upsert: true})
    else
      client[:advertisement].delete_one(relational_id: id)
    end
  end

end
