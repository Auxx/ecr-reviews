class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title
      t.string :author
      t.datetime :posted_at
      t.string :reddit_id
      t.text :url

      t.timestamps
    end
  end
end
