class Advertisement < ActiveRecord::Base

  after_save :save_to_mongo
  after_destroy :remove_from_mongo
  belongs_to :books_group
  has_many :books_group_has_books, through: :books_group
  has_many :books, through: :books_group_has_books
  belongs_to :user

  validate :ativo?

  def self.search(text, user = nil)
    client = Advertisement.mongo_client
    filter = { '$text' => { '$search' => text } }
    filter[:user_id] = user unless user.nil?
    query_result = client[:advertisement].find(
      filter,
      projection: { 'score' => { '$meta' => 'textScore' }, 'titulo' => 1, relational_id: 1, updated_at: 1, user_id: 1}
    ).sort(score: { '$meta' => 'textScore' })
    advertisements = []
    query_result.each do |result|
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

  def self.mongo_client
    Mongo::Client.new(['127.0.0.1:27017'], database: 'escambodelivro_development')
  end

  def self.neo_session
    Neo4j::Session.open(:server_db, 'http://localhost:7474', basic_auth: { username: 'neo4j', password: 'batata'})
  end

  def self.save_to_neo
    session = Advertisement.neo_session
    Neo4j::Node.create({name: 'andreas'}, :red, :green)
  end

  private

  def ativo?
    errors.add(:ativo, 'needs at least one book') if ativo && books.size.zero?
  end

  def remove_from_mongo
    client = Advertisement.mongo_client
    client[:advertisement].delete_one(relational_id: id)
  end

  def save_to_mongo
    client = Advertisement.mongo_client
    if ativo
      client[:advertisement].update_one({relational_id: id}, self.to_json, {upsert: true})
    else
      client[:advertisement].delete_one(relational_id: id)
    end
  end



end
