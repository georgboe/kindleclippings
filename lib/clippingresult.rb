module KindleClippings
  
  class ClippingResult < Array
    
    def highlights
      filter_by_property(:type, :Highlight)
    end
    
    def notes
      filter_by_property(:type, :Note)
    end
    
    def bookmarks
      filter_by_property(:type, :Bookmark)
    end
    
    def by_author(author)
      filter_by_property(:author, author)
    end
    
    def by_book(book)
      filter_by_property(:book_title, book)
    end
    
    private
    
    def filter_by_property(property, value)
      return self unless value
      
      case value
      when String
        self.select { |annotation| annotation.send(property).downcase == value.downcase }
      when Symbol
        self.select { |annotation| annotation.send(property) == value }
      end
    end
    
  end
end