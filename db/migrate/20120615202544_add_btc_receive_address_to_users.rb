class AddBtcReceiveAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :btc_receive_address, :string
  end
end
