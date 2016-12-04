Dependências:
- Ruby 2.2.+
- Rails 4.x
- PostgreSQL
- MongoDB 2.6+ (Versão necessária para a busca textual)
- Neo4j (Testado com a versão 1.1.9)

Instruções:
  Rodar na raiz do projeto:
    bundle install
    rake db:setup
    rails s

  As credenciais para os bancos de dados devem ser alteradas em:
    config/database.yml (PostgreSQL)
    app/models/db_connection.rb (MongoDB e Neo4j)