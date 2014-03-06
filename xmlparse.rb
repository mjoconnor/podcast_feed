require 'nokogiri'
require 'open-uri'
require 'date'

doc = Nokogiri::HTML(open("http://bertcast.libsyn.com/rss"))

results = doc.xpath("//item")

episodes = []

results.each do |node|
	epNumber = node.xpath("title").inner_text().gsub(/\D/,'').to_i
	title = node.xpath("title").inner_text()
	guests = node.xpath("title").inner_text().gsub(/^Episode\s*\#\s*[0-9]*|-|\&|\bME\b|\bMe\b|\band\b|\.$/,'').split(',').map(&:strip)
	pubDate = DateTime.parse(node.xpath("pubdate").text).to_date

	episodes << {'epNumber'=>epNumber, 'title'=>title, 'guests'=>guests.delete_if{|guest| guest.empty?}, 'date'=>pubDate}
end

episodes.sort_by!{ |eps| eps["date"]}

fname = "_includes/table.html"
fdoc = File.open(fname, "w")
fdoc.puts "<table id='table'>"
fdoc.puts "<thead><tr><th>Episode</th><th>Title</th><th>Date</th><th>Guests</th></tr></thead>"
fdoc.puts "<tbody>"

episodes.each do |node|

	node['date'] = node['date'].strftime('%m/%d/%Y')
	fdoc.puts "<tr><td>#{node['epNumber']}</td><td>#{node['title']}</td><td>#{node['date']}</td><td>#{node['guests'].join(', ')}</td></tr>"
end

fdoc.puts "</tbody>"
fdoc.puts "</table>"
fdoc.close