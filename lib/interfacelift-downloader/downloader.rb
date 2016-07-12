class Image < Struct.new(:url, :file_name); end

class InterfaceliftDownloader

  def initialize
    @agent = Mechanize.new
    @agent.redirect_ok = true
    @page_number = 0
  end

  def find_and_save_images( new_page )
    @images = []
    @page_number += 1
    puts "Strona numer: " + @page_number.to_s

    @page = @agent.get new_page
    elements = @page.search("//div[@class='download']/div/a")
    links =[]
    elements.each do |element|
      element.attributes.each do |attribute|
        links.push 'https://interfacelift.com' + attribute[1].value
      end
    end
    begin
    links.each do |link|
      image_name = link.split('/').last
      image_page = @page.link_with(xpath: "//a[contains(@href, '"+image_name+"')]").click
      image_page.save("#{Dir.home}/download_images/"+image_name)
      image = Image.new(link.to_s, image_name.to_s)
      @images << image
      puts "\t"+image.file_name()
    end
    rescue Exception => e
      puts "No i klops :( jedziemy dalej\n #{e.message}"
    end
  end

  def go_to_the_next_page
    next_button = @page.link_with(xpath: "//a[contains(@class, 'selector') and text()='next page >']")
    next_page = next_button.click
    next_page
  end

  def directory_exists?(directory)
    File.directory?(directory)
  end

  def download_images(how_many_pages_to_download)
    if !directory_exists?("#{Dir.home}/download_images")
      Dir.mkdir "#{Dir.home}/download_images"
      ap "Utworzono katalog images"
    end

    find_and_save_images( 'http://interfacelift.com/wallpaper/downloads/date/widescreen/2880x1800' ) #MacBook Pro with Retina
    # find_and_save_images( 'https://interfacelift.com/wallpaper/downloads/date/widescreen/1920x1200/' ) #Full HD
    (how_many_pages_to_download.to_i - 1).times do
      find_and_save_images( go_to_the_next_page )
    end
    ap "Pobieranie zakończono pomyślnie"
  end
end
