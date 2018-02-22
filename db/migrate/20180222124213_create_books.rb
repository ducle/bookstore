class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.integer :category_id
      t.string :title
      t.text :description
      t.decimal :price
      t.string :isbn_10
      t.string :isbn_13
      t.string :image
      t.string :slug

      t.timestamps
    end
    add_index :books, :category_id
    add_index :books, :slug, unique: true
    
  end
end
