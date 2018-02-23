require 'rails_helper'

describe Category, type: :model do
  context "db" do
    context "indexes" do
      it { should have_db_index(:parent_id).unique(false) }
      it { should have_db_index(:slug).unique(true) }
    end

    context "columns" do
      it { should have_db_column(:parent_id).of_type(:integer) }
      it { should have_db_column(:name).of_type(:string).with_options(null: false) }
      it { should have_db_column(:position).of_type(:integer) }
      it { should have_db_column(:slug).of_type(:string) }
    end
  end

  context 'associations' do
    it { should belong_to(:parent) }    
    it { should have_many(:books) }    
    it { should have_many(:children) }    
  end

  context 'validations' do
    it { should validate_presence_of(:name) }    
    it { should validate_uniqueness_of(:name) }    
  end

  context 'attributes' do
    it "has email" do
      expect(build(:subscription, email: "x@y.z")).to have_attributes(email: "x@y.z")
    end
  end

end