class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title, :null => false
      t.string :slug,  :null => false

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end

    add_index :categories, :slug, :unique => true
    
    create_table :categories_items do |t|
      t.references :category
      t.references :item
    end

  end
end
