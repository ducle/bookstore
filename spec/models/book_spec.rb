require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe Book, type: :model do
  context "db" do
    context "indexes" do
      it { should have_db_index(:category_id).unique(false) }
      it { should have_db_index(:slug).unique(true) }
    end

    context "columns" do
      it { should have_db_column(:category_id).of_type(:integer) }
      it { should have_db_column(:title).of_type(:string) }
      it { should have_db_column(:description).of_type(:text) }
      it { should have_db_column(:price).of_type(:decimal) }
      it { should have_db_column(:isbn_10).of_type(:string) }
      it { should have_db_column(:isbn_13).of_type(:string) }
      it { should have_db_column(:image).of_type(:string) }   
      it { should have_db_column(:slug).of_type(:string) }   
    end
  end

  context "attributes" do
    it "has category_id" do
      expect(build(:book, category_id: 1)).to have_attributes(category_id: 1)
    end

    it "has title" do
      expect(build(:book, title: 'title')).to have_attributes(title: 'title')
    end

    it "has description" do
      expect(build(:book, description: 'desc')).to have_attributes(description: 'desc')
    end

    it "has price" do
      expect(build(:book, price: 1)).to have_attributes(price: 1)
    end

    it "has isbn_10" do
      expect(build(:book, isbn_10: '111111111111')).to have_attributes(isbn_10: '111111111111')
    end

    it "has isbn_13" do
      expect(build(:book, isbn_13: '123123')).to have_attributes(isbn_13: '123123')
    end

  end

  context 'libs' do
    it 'should mount ImageUploader' do
      book = build(:book)
      expect(book.image).to be_instance_of(ImageUploader)
    end
  end  

  context 'instance methods' do
    let(:cat1) { create(:category, name: 'cat1', parent_id: nil)}
    let(:cat2) { create(:category, name: 'cat2', parent_id: nil)}
    let(:book1) { create(:book, title: 'book1', category_id: cat1.id)}
    let(:book2) { create(:book, title: 'book2', category_id: cat2.id, image: File.open("#{Rails.root}/spec/fixtures/img.jpg"))}

    describe ".category_name" do
      it 'returns cat name' do
        expect(book1.category_name).to eq cat1.name
      end
    end

    describe ".fore_category_name" do
      it 'returns cat ancestry_name' do
        expect(book1.fore_category_name).to match(cat1.ancestry_name)
        expect(book2.fore_category_name).to match(cat2.ancestry_name)
      end
    end

    describe ".thumb_url" do
      it 'returns thumb version' do
        # expect(book2.thumb_url).to have_dimensions(253, 379)
        expect(book2.thumb_url).to eq book2.image.thumb.url

      end
      
      it 'returns nil' do
        expect(book1.thumb_url).to be_nil
      end
    end

  end
  
end
