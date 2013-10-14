# Nokogiri for you

Nokogiri is an awesome scraping library for Rails.
We can use it to get data from websites that don't
have public APIs. It works by navigating to a URL
and then parses out the HTML into the different tags.
Then, you can access the information through CSS
selectors and persist it to your own database or do
anything you want with it.

Note: You may want to think about why the site you
want to scrape doesn't have a public API in the first
place and whether you're allowed to scrape their data.

So let's jump right in...

## First Things First

- `gem 'nokogiri'` and `require 'open-uri'` in your `Gemfile` and then run `bundle install`.
- You may also want to use `gem 'addressable'` to build the URLs you scrape. This is not necessary, but oh so convenient. I will be using it here.

## Getting Started

First, you open the page you want and load it into
memory, and Nokogiri parses it:

```
url = Addressable::URI.parse("http://newyork.craigslist.org/search/aap/mnh")

query_hash = {"s"      => 0,
              "nh"     => 129,
              "minAsk" => 1800,
              "maxAsk" => 3500}

url.query = URI.encode_www_form(query_hash)
url.query #=> "s=0&nh=129&minAsk=1800&maxAsk=3500"

url.to_s #=> "http://newyork.craigslist.org/search/aap/mnh

page = Nokogiri::HTML(open(url.to_s))
```

## Accessing ze Data

Once you have this, you can access the content with CSS selectors:

`page.css(".row")`

This will return an array of all the elements with class `.row`. In the example URL, `.row` matches each row in the list of apartments. Then, I can do something like this:

```
page.css(".row").each do |row|
  apt_url = row.at_css("a")[:href]
  craigslist_id = apt_url[/\d{6,}/].to_i
  title = row.at_css("a").text

  Listing.create(url: apt_url, title: title, craigslist_id: craigslist_id)
end
```
Note that `#css` returns all matching nodes in the selection while `#at_css
only returns the first`. There are many, many other DOM navigation methods you
can use. Here, have some [docs][nokogiri-docs]

[nokogiri-docs]: http://nokogiri.org/Nokogiri/XML/Node.html

#### BTW...
I use [Selector Gadget][selector-gadget] to find the best CSS selectors for
what I need. It's really good and much quicker than looking through the HTML
yourself.

[selector-gadget]: http://selectorgadget.com/




















