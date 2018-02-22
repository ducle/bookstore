require 'rails_helper'

describe Category, type: :model do

  context '.create!' do

  end


  context 'associations' do
    it { should belong_to(:parent) }    
    it { should have_many(:books) }    
    it { should have_many(:children) }    
  end

  context 'validations' do
    it { should validate_presence_of(:name) }    
  end

  context 'attributes' do
    it { should have_db_column(:parent_id).of_type(:integer) }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_index(:parent_id)  }
  end

end