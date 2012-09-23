# encoding: utf-8
module KindleClippings
  
  class Parser
    
    def parse_file(path)
      file_content = open(path, 'r:utf-8').read
      
      parse(file_content)
    end
    
    def parse(filecontent)
      @clippings = ClippingResult.new
      
      filecontent.split("=" * 10).each do |clipping|
        
        a_clipping = parse_clipping(clipping)
        
        if a_clipping
          @clippings << a_clipping
        end
        
        
      end
      @clippings
    end
    
    private
    
    def parse_clipping(clipping)
      clipping.lstrip!
      
      lines = clipping.lines.to_a
      
      if lines.length < 4
        return nil
      end
      
      first_line = lines[0].strip.scan(/^(.+) \((.+)\)$/i).first
      second_line = lines[1].strip.scan(/^-\s(?:Your\s)?(\w+) (?:on page (\d+) \| |)Loc(?:ation)?\.? ([0-9-]*?) +\| Added on (.+)$/i).first
      
      if first_line.nil?
        title = lines[0].strip
        author = ""
      else
        title, author = *first_line
      end
      type, page, location, date = *second_line
      
      content = lines[3..-1].join("")
      
      Clipping.new(title, author, type.to_sym, location, date, content.strip, page)
    end
  end
end
