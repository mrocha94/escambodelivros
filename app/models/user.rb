class User < ActiveRecord::Base
  include Clearance::User

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
end
