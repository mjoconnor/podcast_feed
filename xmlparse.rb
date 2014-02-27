require 'nokogiri'
require 'open-uri'
require 'date'

doc = Nokogiri::HTML(open("http://bertcast.libsyn.com/rss"))

results = doc.xpath("//item")

episodes = []

results.each do |node|
	epNumber = node.xpath("title").inner_text().gsub(/\D/,'')
	title = node.xpath("title").inner_text()
	guests = node.xpath("title").inner_text().gsub(/^([^-]*)-|\&|ME|Me|and|\./,'').split(',').map(&:strip)
	pubDate = DateTime.parse(node.xpath("pubdate").text).to_date

	episodes << {'epNumber'=>epNumber, 'title'=>title, 'guests'=>guests.delete_if{|guest| guest.empty?}, 'date'=>pubDate.strftime('%B %d, %Y')}
end

puts episodes