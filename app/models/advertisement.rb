class Advertisement < ActiveRecord::Base

  after_save :save_to_mongo
  after_save :save_to_neo
  after_destroy :remove_from_mongo
  after_destroy :remove_from_neo
  belongs_to :books_group
  has_many :books_group_has_books, through: :books_group
  has_many :books, through: :books_group_has_books
  belongs_to :user

  validate :ativo?

  def self.text_search(text, user = nil)
    advertisements = []
    client = DbConnection.mongo
    filter = { '$text' => { '$search' => text } }
    filter[:user_id] = user unless user.nil?
    query_result = client[:advertisement].find(
      filter,
      projection: { 'score' => { '$meta' => 'textScore' }, 'titulo' => 1, relational_id: 1, updated_at: 1, user_id: 1}
    ).sort(score: { '$meta' => 'textScore' })
    
    query_result.each do |result|
      advertisements.push Advertisement.new(id: result[:relational_id], titulo: result[:titulo], updated_at: result[:updated_at], user_id: result[:user_id])
    end
    advertisements
  end

  def self.recommendation_search(user)
    advertisements = []
    session = DbConnection.neo4j
    session.query('MATCH p = (user: User{user_id:{id}})-[*4..8]-(ad: Advertisement) WHERE NOT exists((user)-[]->(ad)) RETURN ad, sum(1.0/length(p)) ORDER BY sum(1.0/length(p))', id: user).each do |result|
      advertisements.push Advertisement.new(id: result[0][:ad_id], titulo: result[0][:titulo], updated_at: result[0][:updated_at], user_id: result[0][:user_id])
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

  def remove_from_neo
    session = DbConnection.neo4j
    session.query('MATCH (ad: Advertisement{ad_id:{id}}) detach delete ad', id: id)
  end

  def save_to_neo
    if ativo
      session = DbConnection.neo4j
      query = session.query.merge(u: { User: { user_id: user.id } })
                    .merge(a: { Advertisement: { ad_id: id }})
                    .set(a: {titulo: titulo || "", updated_at: updated_at, user_id: user_id})

      query.merge('(u)-[:PUBLISH]->(a)').exec

      books.each do |book|
        query.merge(b: { Book: { book_id: book.id } })
             .merge('(a)-[:ADVERTISE]->(b)').exec
      end
    else
      remove_from_neo
    end

    # u = session.query("MERGE (u:User {id: #{user.id}}) RETURN u").first.u
    # a = session.query("MERGE (a:Advertisement {id: #{id}}) RETURN a").first.a
    # session.query("MERGE #{u}-[:PUBLISH]->#{a}")
  end

end
