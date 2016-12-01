class BooksGroupHasBookController < ApplicationController

  before_action :set_advertisement, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :check_user, only: [:new, :create, :show, :edit, :update]

  def new
    @books_group_has_book = BooksGroupHasBook.new
    @books = Book.all
  end

  def create
    # @books_group_has_book = BooksGroupHasBook.new
    # @advertisement = Advertisement.find_by_id(params[:advertisement_id])
    # @books_group_has_book.books_group = @advertisement.books_group
    # used_book = params[:books_group_has_book]
    # @books_group_has_book.estado = used_book[:estado]
    # @books_group_has_book.ano_compra = used_book[:ano_compra]
    # @books_group_has_books.book = Book.find_by_id(used_book[:book_id])

    @books_group_has_books = BooksGroupHasBook.new(books_group_has_book_from_params)
    @advertisement.books_group.books_group_has_book << @books_group_has_books
    if @advertisement.save
      redirect_to edit_advertisement_path(@advertisement)
    else
      flash[:warning] = @advertisement.errors.full_messages
      render 'new'
    end
  end

  def destroy
    book = BooksGroupHasBook.find_by_id(params[:id])
    # @groupable = edit_advertisement_path(@advertisement)
    book.destroy
    redirect_to params[:return_url]
  end

  private

    def set_advertisement
      puts params
      @advertisement = Advertisement.find_by_id(params[:advertisement_id])
    end

    def books_group_has_book_from_params
      return params.require(:books_group_has_book).permit(:book_id, :estado, :ano_compra)
    end

    def check_user
      return if @advertisement.user.id == current_user.id
      flash[:notice] = 'Unauthorized'
      redirect_to advertisement_path(@advertisement)
    end
end
