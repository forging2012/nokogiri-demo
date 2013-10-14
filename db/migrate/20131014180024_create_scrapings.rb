class CreateScrapings < ActiveRecord::Migration
  def change
    create_table :scrapings do |t|
      t.string :title
      t.integer :craigslist_id, limit: 8
      t.string :url

      t.timestamps
    end
  end
end
