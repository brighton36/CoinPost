class CreateShippingPolicies < ActiveRecord::Migration
  def change
    create_table :shipping_policies do |t|
      t.string :label

      t.timestamps
    end
  end
end
