# encoding: utf-8
module KindleClippings
  class Clipping
    require 'date'
    
    attr_accessor :book_title, :author, :type, :location, :added_on, :content, :page
    DEFAULT_DATE_FORMAT = "%A, %B %d, %Y, %I:%M %p"
    KINDLE_TOUCH_DATE_FORMAT = "%A, %B %d, %Y  %I:%M:%S %p"
    ALTERNATIVE_DATE_FORMAT = "%A, %d %B %y %H:%M:%S %Z"

    def initialize()
    end

    def initialize(title, author, type, location, added_on, content, page = "0")
      @book_title = title
      @author = author
      @type = type
      @location = location

      [DEFAULT_DATE_FORMAT, KINDLE_TOUCH_DATE_FORMAT, ALTERNATIVE_DATE_FORMAT].each do |format|
        break if @added_on

        begin
          @added_on = DateTime.strptime(added_on, format)
        rescue ArgumentError => e
        end
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
