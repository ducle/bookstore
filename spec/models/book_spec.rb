require 'rails_helper'

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
end
