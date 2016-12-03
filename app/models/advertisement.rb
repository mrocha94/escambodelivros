class Advertisement < ActiveRecord::Base

  after_save :save_to_mongo
  after_save :save_to_neo
  after_destroy :remove_from_mongo
  belongs_to :books_group
  has_many :books_group_has_books, through: :books_group
  has_many :books, through: :books_group_has_books
  belongs_to :user

  validate :ativo?

  def self.search(text, user = nil)
    client = DbConnection.mongo
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

  private

  def ativo?
    errors.add(:ativo, 'needs at least one book') if ativo && books.size.zero?
  end

  def remove_from_mongo
    client = DbConnection.mongo
    client[:advertisement].delete_one(relational_id: id)
  end

  def save_to_mongo
    client = DbConnection.mongo
    if ativo
      client[:advertisement].update_one({relational_id: id}, self.to_json, {upsert: true})
    else
      client[:advertisement].delete_one(relational_id: id)
    end
  end

  def save_to_neo
    session = DbConnection.neo4j
    query = session.query.merge(u: { User: { id: user.id } })
                   .merge(a: { Advertisement: { id: id } })

    query.merge('(u)-[:PUBLISH]->(a)').exec

    books.each do |book|
      query.merge(b: { Book: { id: book.id } })
           .merge('(a)-[:ADVERTISE]->(b)').exec
    end

    # u = session.query("MERGE (u:User {id: #{user.id}}) RETURN u").first.u
    # a = session.query("MERGE (a:Advertisement {id: #{id}}) RETURN a").first.a
    # session.query("MERGE #{u}-[:PUBLISH]->#{a}")
  end

end
