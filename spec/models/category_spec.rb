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
    it "has name" do
      expect(build(:category, name: "name")).to have_attributes(name: "name")
    end

    it "has position" do
      expect(build(:category, position: 1)).to have_attributes(position: 1)
    end

    it "has slug" do
      expect(build(:category, slug: 'slug')).to have_attributes(slug: 'slug')
    end
  end

  context 'libs' do
    it 'should include acts_as_list' do
      cat = create(:category)
      expect(cat.position).not_to be_nil
    end

    it 'should have friendly_id' do
      cat = create(:category)
      expect(cat.slug).not_to be_nil
    end
  end

  context 'scopes' do

    describe ".roots" do
      before do
        @cat1 = create(:category, name: 'cat1', parent_id: nil)
        @cat2 = create(:category, name: 'cat2', parent_id: @cat1.id)
      end
      it 'returns orphan categories' do
        expect(Category.roots.to_a).to match_array [@cat1]
      end

      it 'not return child categories' do
        expect(Category.roots.to_a).not_to match_array [@cat2]
      end
    end
  end

  context 'instance methods' do
    let(:cat1) { create(:category, name: 'cat3', parent_id: nil)}
    let(:cat2) { create(:category, name: 'cat4', parent_id: cat1.id)}
    describe ".parent_name" do
      it 'returns parent name' do
        expect(cat2.parent_name).to eq cat1.name
      end
      
      it 'returns nil' do
        expect(cat1.parent_name).to be_nil
      end
    end

    describe ".ancestry_name" do
      it 'returns parent and current name' do
        expect(cat2.ancestry_name).to match(cat1.name)
        expect(cat2.ancestry_name).to match(cat2.name)
        expect(cat2.ancestry_name).to eq [cat1.name, cat2.name].join(' > ')
      end
      
      it 'returns nil' do
        expect(cat1.ancestry_name).to eq cat1.name
      end
    end

  end


end