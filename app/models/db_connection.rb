class DbConnection

  def self.mongo
    Mongo::Client.new(['127.0.0.1:27017'], database: 'escambodelivro_development')
  end

  def self.neo4j
    Neo4j::Session.open(:server_db, 'http://localhost:7474', basic_auth: { username: 'neo4j', password: 'batata'})
  end
end
