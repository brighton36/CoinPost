class AddRedditAttributesToItemAndUser < ActiveRecord::Migration
  def change
    add_column :users, :reddit_username, :string
    add_column :users, :reddit_password, :string

    add_column :items, :reddit_url, :string
  end
end
