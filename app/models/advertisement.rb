class Advertisement < ActiveRecord::Base

  after_save :save_to_mongo
  after_destroy :remove_from_mongo
  belongs_to :books_group
  has_many :books_group_has_books, through: :books_group
  has_many :books, through: :books_group_has_books
  belongs_to :user

  validate :ativo?
  #
  # def self.search text
  #   client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
  #   client[:advertisement].find(
  #     {'$text' => {'$search' => text}},
  #     { fields: {score: {'$meta' => 'textScore'}}}).sort({score:{'$meta' => 'textScore'}})
  # end

  # def self.search text
  #   client = Mongo::Client.new(['127.0.0.1:27017'], database: 'test')
  #   results = client[:advertisement]
  #     .find(
  #       { '$text' => { '$search' => text } },
  #       projection: { score: { '$meta' => 'textScore' } }
  #     ) #.sort(score: { '$meta' => 'textScore' })
  #   results.each {|doc| puts doc}
  #   results
  # end

  def self.search(text)
    client = Mongo::Client.new(['127.0.0.1:27017'], database: 'test')
    query_result = client[:advertisement].find(
      { '$text' => { '$search' => text } },
      projection: { 'score' => { '$meta' => 'textScore' }, 'titulo' => 1, relational_id: 1, updated_at: 1, user_id: 1}
    ).sort({score:{'$meta' => 'textScore'}})
    # db.advertisement.find( {"$text": { "$search": "Harry" } }, { "titulo": 1 });
    advertisements = []
    query_result.each do |result|
      # puts "aaaaaaaaaaaaaaaaaaaaaaaaa: #{result}"
      advertisements.push Advertisement.new(id: result[:relational_id], titulo: result[:titulo], updated_at: result[:updated_at], user_id: result[:user_id])
    end
    advertisements
  end

  def to_json
    json = {}
    json[:relational_id] = id
    json[:titulo] = titulo
    json[:descricao] = descricao
    json[:updated_at] = updated_at
    json[:user_id] = user_id
    json[:books] = []
    books.each { |b| json[:books].push b.to_json }
    json
  end

  private

  def ativo?
    errors.add(:ativo, 'needs at least one book') if ativo && books.size.zero?
  end

  def remove_from_mongo
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
    client[:advertisement].delete_one(relational_id: id)
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
