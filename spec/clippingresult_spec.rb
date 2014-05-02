# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ClippingResult" do
  
  before(:each) do
    @clippings = KindleClippings::ClippingResult.new

    @clippings << KindleClippings::Clipping.new('A highlighted book', 'Malcolm Gladwell', :Highlight, '1942', 'Friday, October 23, 2009, 09:37 PM', 'This is the content.')
    @clippings << KindleClippings::Clipping.new('Another highlighted book', 'Name of author', :Highlight, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    @clippings << KindleClippings::Clipping.new('A bookmark book', 'Malcolm Gladwell', :Bookmark, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    @clippings << KindleClippings::Clipping.new('Another bookmark book', 'Name of author', :Bookmark, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    @clippings << KindleClippings::Clipping.new('A note', 'Malcolm Gladwell', :Note, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    @clippings << KindleClippings::Clipping.new('Another note', 'Name of author', :Note, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')    
    @clippings << KindleClippings::Clipping.new('Born to Run', 'Christopher Mcdougall', :Highlight, '1934', 'Wednesday, December 23, 2009, 09:37 PM', '“Let us live so that when we come to die, even the undertaker will be sorry,”')
    @clippings << KindleClippings::Clipping.new('Born to Run', 'Christopher Mcdougall', :Highlight, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'He’d discovered why those Russian sprinters were leaping off ladders (besides strengthening lateral muscles, the trauma teaches nerves to fire more rapidly, which decreases the odds of training injuries).')
  end
  
  it "should give me all highlights" do
    @clippings.expects(:filter_by_property).with(:type, :Highlight)
    @clippings.highlights
  end
  
  it "should give me all notes" do
    @clippings.expects(:filter_by_property).with(:type, :Note)
    @clippings.notes
  end
  
  it "should give me all bookmarks" do
    @clippings.expects(:filter_by_property).with(:type, :Bookmark)
    @clippings.bookmarks
  end
  
  it "should give me all clippings for a certain type" do
    
    @clippings.length.should eql(8)
    
    highlights = @clippings.send(:filter_by_property, :type, :Highlight)
    highlights.length.should eql(4)
    highlights[0].book_title.should eql('A highlighted book')
    highlights[1].book_title.should eql('Another highlighted book')
    
    bookmarks = @clippings.send(:filter_by_property, :type, :Bookmark)
    bookmarks.length.should eql(2)
    bookmarks[0].book_title.should eql('A bookmark book')
    bookmarks[1].book_title.should eql('Another bookmark book')
    
    notes = @clippings.send(:filter_by_property, :type, :Note)
    notes.length.should eql(2)
    notes[0].book_title.should eql('A note')
    notes[1].book_title.should eql('Another note')
    
    invalid_parameter = @clippings.send(:filter_by_property, :type, nil)
    invalid_parameter.length.should eql(8)

    clippings = @clippings.send(:filter_by_property, :type, /Bookmark|Note/)
    clippings.length.should eql(4)
    clippings[0].book_title.should eql('A bookmark book')
    clippings[1].book_title.should eql('Another bookmark book')
    clippings[2].book_title.should eql('A note')
    clippings[3].book_title.should eql('Another note')
  end
  
  it "should give me all annotations by author" do
    result = @clippings.by_author("malcolm gladwell")
    result.length.should eql(3)
  end
  
  it "should give me all annotations by author matching a regex" do
    result = @clippings.by_author(/malcolm/)
    result.length.should eql(0)

    result = @clippings.by_author(/Malcolm/)
    result.length.should eql(3)

    result = @clippings.by_author(/malcolm/i)
    result.length.should eql(3)
  end

  it "should give me all annotations by book" do
    result = @clippings.by_book("born to run")
    result.length.should eql(2)
  end

  it "should give me all annotations by book matching a regex" do
    result = @clippings.by_book(/born/)
    result.length.should eql(0)

    result = @clippings.by_book(/Born/)
    result.length.should eql(2)

    result = @clippings.by_book(/born/i)
    result.length.should eql(2)
  end

  it "should filter annotations by date" do
    from = Date.new(2009, 10, 23)
    to = Date.new(2009, 11, 1)
    result = @clippings.by_date(from, to)
    result.length.should eql(1)
  end

  it "should return all items if date is invalid" do
    expected = @clippings.length

    @clippings.by_date(nil, Date.today).length.should eql(expected)
    @clippings.by_date(Date.today, nil).length.should eql(expected)

  end
end
