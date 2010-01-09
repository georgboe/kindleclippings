# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ClippingResult" do
  
  before(:each) do
    @clippings = KindleClippings::ClippingResult.new

    @clippings << KindleClippings::Clipping.new('A highlighted book', 'Name of author', :Highlight, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    @clippings << KindleClippings::Clipping.new('Another highlighted book', 'Name of author', :Highlight, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    @clippings << KindleClippings::Clipping.new('A bookmark book', 'Name of author', :Bookmark, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    @clippings << KindleClippings::Clipping.new('Another bookmark book', 'Name of author', :Bookmark, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    @clippings << KindleClippings::Clipping.new('A note', 'Name of author', :Note, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    @clippings << KindleClippings::Clipping.new('Another note', 'Name of author', :Note, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
  end
  
  it "should give me all highlights" do
    @clippings.expects(:filter_by_type).with(:Highlight)
    @clippings.highlights
  end
  
  it "should give me all notes" do
    @clippings.expects(:filter_by_type).with(:Note)
    @clippings.notes
  end
  
  it "should give me all bookmarks" do
    @clippings.expects(:filter_by_type).with(:Bookmark)
    @clippings.bookmarks
  end
  
  it "should give me all clippings for a certain type" do
    
    @clippings.length.should eql(6)
    
    highlights = @clippings.send(:filter_by_type, :Highlight)
    highlights.length.should eql(2)
    highlights[0].book_title.should eql('A highlighted book')
    highlights[1].book_title.should eql('Another highlighted book')
    
    bookmarks = @clippings.send(:filter_by_type, :Bookmark)
    bookmarks.length.should eql(2)
    bookmarks[0].book_title.should eql('A bookmark book')
    bookmarks[1].book_title.should eql('Another bookmark book')
    
    notes = @clippings.send(:filter_by_type, :Note)
    notes.length.should eql(2)
    notes[0].book_title.should eql('A note')
    notes[1].book_title.should eql('Another note')
    
    invalid_parameter = @clippings.send(:filter_by_type, nil)
    invalid_parameter.length.should eql(6)
  end
end