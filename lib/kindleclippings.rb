# encoding: utf-8
module KindleClippings
  
  class Parser
    ['clipping', 'clippingresult'].each { |file| require File.expand_path(File.dirname(__FILE__) + '/' + file) }
    
    def parse_file(path)
      
      file_content = String.new
      
      if RUBY_VERSION =~ /^1\.8/
        file_content = open(path).read
      else
        file_content = File.open(path, :encoding => "UTF-8").read
      end
      
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
      
      lines = Array.new
      
      if RUBY_VERSION >= "1.9.1"
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