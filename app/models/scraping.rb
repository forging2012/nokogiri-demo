class Scraping < ActiveRecord::Base
  extend CraigslistScraper

  attr_accessible :craigslist_id, :title, :url

  validates :craigslist_id, uniqueness: true
  validates :craigslist_id, :title, :url, presence: true

end
