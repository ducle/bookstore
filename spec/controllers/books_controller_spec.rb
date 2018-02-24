require 'rails_helper'

RSpec.describe BooksController, :type => :controller do
  let(:cat) { create :category }
  let(:book1) { create :book, category_id: cat.id }

  context "GET index" do
    before do
      @user = create :user, email: 'myemail@mailer.com', password: 'pwd1234'
      sign_in @user
    end

    it "assigns books to the view" do
      get :index
      expect(assigns(:books)).to match_array([book1])
    end

    it "renders the view index" do
      get :index
      expect(response).to render_template("index")
    end

  end

  context "GET new" do
    before do
      @user = create :user, email: 'myemail@mailer.com', password: 'pwd1234'
      sign_in @user
    end
    it "assigns a blank book to the view" do
      get :new
      expect(assigns(:book)).to be_a_new(Book)
    end

  end
  
  context "GET edit" do
    before do
      @user = create :user, email: 'myemail@mailer.com', password: 'pwd1234'
      sign_in @user
    end

    it "assigns a book to the view" do
      get :edit, params: {id: book1.id}
      expect(assigns(:book)).to eq book1
    end

    it "renders the view edit" do
      get :edit, params: {id: book1.id}
      expect(response).to render_template("edit")
    end

  end

  context "POST create" do
    before do
      @user = create :user, email: 'myemail@mailer.com', password: 'pwd1234'
      sign_in @user
    end

    it "add a book" do
      expect{
        post :create, params: {book: attributes_for(:book, title: 'book2', price: 10, isbn_10: '1234512345', isbn_13: '1234512345-123', category_id: cat.id)}
      }.to change(Book, :count)
    end

    it "redirect to /books" do
      post :create, params: {book: attributes_for(:book, title: 'book2', price: 10, isbn_10: '1234512345', isbn_13: '1234512345-123', category_id: cat.id)}
      expect(response).to redirect_to books_path
    end

    it "render new with errors" do
      post :create, params: {book: {title: 'book2', price: 10, isbn_10: '1234512345', isbn_13: '1234512345-123'}}
      expect(response).to render_template(:new)
    end

  end


  describe "PUT update" do
    it "responds to PUT" do
      b = assigns[:book]
      put :update, params: {id: book1.id, book: {title: 'changed title' }}
      # expect(book1.title).to eql 'change title'
      expect(assigns(:book)).not_to be_nil
      # b.title.to eq  'change title'
      # expect(assigns(:book).title).to eq 'change title'
    end

    it "requires the :id parameter" do
      expect { put :update }.to raise_error(Exception)
    end


  end

  describe "#destroy" do
    it "responds to DELETE" do
      # delete :destroy, :id => "anyid"
      # expect(response.body).to eq "destroy called"
    end
  end
end