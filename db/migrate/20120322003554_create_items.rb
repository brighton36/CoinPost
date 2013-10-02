class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :creator, :as => :user, :null => false
      t.references :shipping_policy
      t.references :return_policy

      t.string :btc_receive_address, :null => false
      t.string :title, :null => false
      t.string :location, :null => false
      t.string :slug, :null => false
      
      t.text :description, :null => false

      t.decimal :price_in_cents, :precision => 24, :scale => 0, :null => false
      t.integer :quantity_listed, :null => false

      # This is a cache of the sum of quantity_purchased on the purchases collection
      # we're denormalizing this to keep our queries sane, and performance up:
      t.integer :quantity_purchased, :null => false, :default => 0

      t.boolean :enabled, :null => false, :default => true

      t.timestamp :expires_at, :null => false
      t.timestamp :lists_at, :null => false

      t.timestamps
    end

    add_index :items, :slug, :unique => true
    add_index :items, :expires_at
    add_index :items, :lists_at
  end
end
