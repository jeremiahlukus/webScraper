require 'open-uri'
require 'nokogiri'
require 'csv'



url = "https://www.airbnb.com/s/Atlanta--GA--United-States?allow_override%5B%5D=&s_tag=XkcShjhQ&section_offset="
#https://www.airbnb.com/s/Atlanta--GA--United-States/homes?allow_override%5B%5D=&s_tag=XkcShjhQ&section_offset=3
page = Nokogiri::HTML(open(url))



#Find the max number of pages and stores in max_page
page_numbers = []
page.css("div.numberContainer_1bdke5s").each do |line|
  page_numbers << line.text
end
max_page = page_numbers.pop
#initalize empty array
name = []
price = []
review = []

#loop once for every page of search results
max_page.to_i.times do |i|
#open search result page
  #
  #https://www.airbnb.com/s/Atlanta/homes?allow_override%5B%5D=&place_id=ChIJYe3PfUei9YgRvqJnKRF6OoU&s_tag=qqgciavv&section_offset=1
  #
  #https://www.airbnb.com/s/Atlanta/homes?allow_override%5B%5D=&place_id=ChIJYe3PfUei9YgRvqJnKRF6OoU&s_tag=qqgciavv&section_offset=2
  #
  #
url = "https://www.airbnb.com/s/Atlanta/homes?allow_override%5B%5D=&place_id=ChIJYe3PfUei9YgRvqJnKRF6OoU&s_tag=qqgciavv&section_offset=#{i+1}"
page = Nokogiri::HTML(open(url))

#store data in arrays
  page.css('div.ratingContainer_inline_36rlri').each do |line|
    review << line.text
  end
  page.css('div.ellipsized_1iurgbx').each do |line|
    name << line.text.strip
  end
  puts name.to_s.gsub(/[0-9$]/,'')
  #puts name.to_s.gsub(/\d/,"").gsub() 
  page.css('div.inline_g86r3e').each do |line|
    price << line.text
  end
end


CSV.open("airbnb.csv", "w") do |file|
  file << ["Listing Name", "Price", "Reviews"]
  name.length.times do |i|
    file << [name[i].to_s.gsub(/[0-9$]/,''), price[i], review[i]]
  end
end

#span data-reactid="

#span class="text_5mbkop-o_O-size_small_1gg2mc-o_O-weight_bold_153t78d-o_O-inline_g86r3e" data-reactid
