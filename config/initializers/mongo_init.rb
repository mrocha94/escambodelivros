client = Mongo::Client.new(['127.0.0.1:27017'], database: 'escambodelivro_development')
client[:advertisement].indexes.create_one({'$**' => 'text'})