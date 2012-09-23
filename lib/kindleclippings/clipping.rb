# encoding: utf-8
module KindleClippings
  class Clipping
    require 'date'
    
    attr_accessor :book_title, :author, :type, :location, :added_on, :content, :page
    KINDLE_TOUCH_DATE_FORMAT = "%A, %B %d, %Y  %I:%M:%S %p"

    def initialize()
    end

    def initialize(title, author, type, location, added_on, content, page = "0")
      @book_title = title
      @author = author
      @type = type
      @location = location

      begin
        @added_on = DateTime.strptime(added_on, "%A, %B %d, %Y, %I:%M %p")
      rescue ArgumentError => e
        @added_on = DateTime.strptime(added_on, KINDLE_TOUCH_DATE_FORMAT )
      end

      @content = content
      @page = page.to_i
    end
    
    def to_s
      "#{@book_title} (#{author})\n" +
      "- #{@type} #{('on Page ' + @page.to_s + ' | ') if @page > 0}Loc. #{@location} | Added on #{@added_on.strftime('%A, %B %d, %Y, %I:%M %p')}\n\n" +
      "#{@content}"
    end
  end
end
