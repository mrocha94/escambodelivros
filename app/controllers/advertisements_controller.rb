class AdvertisementsController < ApplicationController
  before_action :require_login, only: [:user_advertisements]
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  # GET /advertisements
  # GET /advertisements.json
  def index
    search = params[:search]
    if search && search.size > 0
      @advertisements = Advertisement.search(search)
    else
      @advertisements = Advertisement.where(ativo: true)
    end
  end

  def user_advertisements
    search = params[:search]
    if search && search.size > 0
      @advertisements = Advertisement.search(search, current_user.id)
    else
      @advertisements = Advertisement.where(user_id: current_user.id)
    end
  end

  # GET /advertisements/1
  # GET /advertisements/1.json
  def show
  end

  # GET /advertisements/new
  def new
    @advertisement = Advertisement.new
    @advertisement.user_id = current_user.id
    @advertisement.books_group = BooksGroup.create
    @advertisement.save
    # client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
    # collection = client[:advertisement]
    # collection.insert_one(relational_id: @advertisement.id)
    redirect_to edit_advertisement_path(@advertisement)
  end
  # GET /advertisements/1/edit
  def edit
  end

  # POST /advertisements
  # POST /advertisements.json
  def create
    @advertisement = Advertisement.new(advertisement_params)
    respond_to do |format|
      if @advertisement.save
        format.html { redirect_to @advertisement, notice: 'Advertisement was successfully created.' }
        format.json { render :show, status: :created, location: @advertisement }
      else
        format.html { render :new }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advertisements/1
  # PATCH/PUT /advertisements/1.json
  def update

    respond_to do |format|
      if @advertisement.update(advertisement_params)
        # client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
        # collection = client[:advertisement]
        # collection.update_one({relational_id: @advertisement.id}, { '$set' => { descricao: @advertisement.descricao,  }})

        format.html { redirect_to edit_advertisement_path(@advertisement), notice: 'Advertisement was successfully updated.' }
        format.json { render :edit, status: :ok, location: @advertisement }
      else
        flash[:warning] = @advertisement.errors.full_messages
        format.html { render :edit }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advertisements/1
  # DELETE /advertisements/1.json
  def destroy
    @advertisement.destroy
    respond_to do |format|
      format.html { redirect_to advertisements_url, notice: 'Advertisement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advertisement
      @advertisement = Advertisement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advertisement_params
      params.require(:advertisement).permit(:titulo, :descricao, :ativo)
    end

    def check_user
      return if @advertisement.user.id == current_user.id
      flash[:notice] = 'Unauthorized'
      redirect_to advertisement_path(@advertisement)
    end
end
