class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :item
      t.references :purchaser

      t.string :btc_receive_address, :null => false
      t.decimal :price_in_cents, :precision => 24, :scale => 0, :null => false
      t.integer :quantity_purchased, :null => false

      t.integer :rating_on_purchaser, :null => false, :default => 0
      t.integer :rating_on_seller,    :null => false, :default => 0

      t.text :fulfillment_notes
      t.text :comment_on_purchaser
      t.text :comment_on_seller

      t.timestamp :payment_sent_at
      t.timestamp :item_sent_at

      t.timestamps
    end
  end
end
