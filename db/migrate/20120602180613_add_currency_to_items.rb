class AddCurrencyToItems < ActiveRecord::Migration
  def change
    add_column :items, :price_currency, :string, :null => false, :default => 'BTC'
  end
end
