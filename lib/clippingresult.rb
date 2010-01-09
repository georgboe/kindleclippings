module KindleClippings
  
  class ClippingResult < Array
    
    def highlights
      filter_by_type(:Highlight)
    end
    
    def notes
      filter_by_type(:Note)
    end
    
    def bookmarks
      filter_by_type(:Bookmark)
    end
    
    private
    
    def filter_by_type(type)
      return self unless type
      self.select { |item| item.type == type }
    end
    
  end
end