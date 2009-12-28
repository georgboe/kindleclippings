# encoding: utf-8
module KindleClippings
  
  class ClippingParser
    require File.expand_path(File.dirname(__FILE__) + '/clipping.rb')
    
    def parse_file(path)
      parse(open(path).read)
    end
    
    def parse(filecontent)
      @clippings = Array.new
      
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
      
      lines = Array.new
      
      if RUBY_VERSION == "1.9.1"
        lines = clipping.lines.to_a
      else
        lines = clipping.to_a
      end
      
      if lines.length < 4
        return nil
      end
      
      first_line = lines[0].strip.scan(/^(.+) \((.+)\)$/i).first
      second_line = lines[1].strip.scan(/^- (.+?) Loc. ([0-9-]*?) \| Added on (.+)$/i).first
      
      title, author = *first_line
      type, location, date = *second_line
      content = String.new
      
      if type == "Note"
        content = lines[3..-1].join("")
      else
        content = lines[3]
      end
      Clipping.new(title, author, type.to_sym, location, date, content.strip)
    end
  end
end