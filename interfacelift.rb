require 'awesome_print'
require 'open-uri'
require 'mechanize'
require 'net/http'
require 'fileutils'

@agent = Mechanize.new
@page
@page_number = 0
def find_and_save_images( new_page )
  @page_number += 1
  puts "Strona numer: " + @page_number.to_s

  @page = @agent.get new_page
  elements = @page.search("//div[@class='download']/div/a")
  links =[]
  elements.each do |element|
    element.attributes.each do |attribute|
      links.push 'http://interfacelift.com' + attribute[1].value
    end
  end

  links.each do |link|
    image_name = link.split('/').last
    puts "\t"+image_name
    open(link) {|f|
       File.open('images/'+image_name,"wb") do |file|
         file.puts f.read
       end
    }
  end

  rescue
    puts "No i klops :( jedziemy dalej"
end

def go_to_the_next_page
  next_button = @page.link_with(xpath: "//a[contains(@class, 'selector') and text()='next page >']")
  next_page = next_button.click
  next_page
end

def directory_exists?(directory)
  File.directory?(directory)
end


if !directory_exists?("images")
  Dir.mkdir 'images'
end

agent = Mechanize.new
find_and_save_images( 'http://interfacelift.com/wallpaper/downloads/date/widescreen/2880x1800' ) #MacBook Pro with Retina
# find_and_save_images( 'https://interfacelift.com/wallpaper/downloads/date/widescreen/1920x1200/' ) #Full HD
49.times do
  find_and_save_images( go_to_the_next_page )
end
puts "Pobieranie zakończono pomyślnie"
