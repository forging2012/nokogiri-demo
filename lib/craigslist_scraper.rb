module CraigslistScraper
  def start(page_num = 0)
    url = Addressable::URI.parse("http://newyork.craigslist.org/search/aap/mnh")

    fetch_paginated_pages(url)
  end


  def fetch_paginated_pages(url, page_num = 0)
    query_hash = {"s"      => page_num * 100,
                  "nh"     => 129,
                  "minAsk" => 1800,
                  "maxAsk" => 3500}
    url.query = URI.encode_www_form(query_hash)

    page = Nokogiri::HTML(open(url.to_s))
    scrape_page(page, url)

    fetch_paginated_pages(url, page_num + 1) if page_num < 25
  end

  def scrape_page(page, url)
    page.css(".row").each do |row|
      apt_url_path = row.css("a")[1][:href]
      apt_url = url.dup
      apt_url.path = apt_url_path
      apt_url.query = nil

      craigslist_id = apt_url_path[/\d{6,}/].to_i
      title = row.css("a")[1].text

      s = Scraping.create(url:           apt_url.to_s,
                          title:         title,
                          craigslist_id: craigslist_id)
    end
  end
end