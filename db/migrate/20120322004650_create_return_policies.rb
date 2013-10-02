class CreateReturnPolicies < ActiveRecord::Migration
  def change
    create_table :return_policies do |t|
      t.string :label

      t.timestamps
    end
  end
end
