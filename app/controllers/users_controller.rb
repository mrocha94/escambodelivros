class UsersController < Clearance::UsersController
  
  def create
    @user = user_from_params

    if @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      flash[:warning] = @user.errors.full_messages
      render template: "users/new"
    end
  end

  private

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    nome = user_params.delete(:nome)
    cpf = user_params.delete(:cpf)
    telefone = user_params.delete(:telefone)
    ano = user_params.delete(:"data_nascimento(1i)").to_i
    ano = ano.zero? ? Time.now.year : ano
    mes = user_params.delete(:"data_nascimento(2i)").to_i
    mes = mes.zero? ? Time.now.month : mes
    dia = user_params.delete(:"data_nascimento(3i)").to_i
    dia = dia.zero? ? Time.now.day : dia
    data_nascimento = Date.new ano, mes, dia
    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
      user.nome = nome
      user.cpf = cpf
      user.telefone = telefone
      user.data_nascimento = data_nascimento
    end
  end
end
