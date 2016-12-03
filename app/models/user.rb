class User < ActiveRecord::Base
  include Clearance::User

  after_save :save_to_neo

  has_many :advertisements

  validates :nome, presence: true
  validates :cpf, presence: true
  validates :data_nascimento, presence: true
  validates :telefone, presence: true
  validate :cpf_valid?

  def cpf_valid?
    (0..1).each do |j|
      soma = 0
      (0..(8 + j)).each do |i|
        soma += (10 - i + j) * cpf[i].to_i
      end
      verificador = (soma * 10) % 11
      verificador = verificador > 9 ? 0 : verificador
      if verificador != cpf[9 + j].to_i
        errors.add(:cpf, 'is invalid')
        break
      end
    end
  end

  private

  def save_to_neo
    session = DbConnection.neo4j
    session.query.merge(u: { User: { user_id: id } }).set(u: { name: nome })
  end
end
