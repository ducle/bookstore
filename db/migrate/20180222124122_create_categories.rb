class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :position
      t.string :slug

      t.timestamps
    end
    add_index :categories, :slug, unique: true
  end
end
