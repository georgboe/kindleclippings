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

    def <=>(other_clipping)
      if @book_title != other_clipping.book_title
        return @book_title <=> other_clipping.book_title
      end
      # Same book

      if @page != other_clipping.page
        return @page <=> other_clipping.page
      end
      # Same book and page

      if @location != other_clipping.location
        return locations_cmp(@location, other_clipping.location)
      end
      # Same book, page and location

      @added_on <=> other_clipping.added_on
    end

    private

    def locations_cmp(a, b)
      return 0 if a == b

      a_parts = a.split('-').map(&:to_i)
      b_parts = b.split('-').map(&:to_i)

      if a_parts[0] != b_parts[0] # beginning differs
        return a_parts[0] <=> b_parts[0] # compare by beginning
      end
      # Same beginning

      if a_parts[1].nil? || b_parts[1].nil? # end missing from a location
        return 0 # consider equal
      end

      a_parts[1] <=> b_parts[1] # compare by end
    end
  end
end
