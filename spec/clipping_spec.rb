# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Clipping" do
  
  it "should parse a date correctly" do
    clipping = KindleClippings::Clipping.new('Book title', 'Name of author', :Highlight, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    clipping.added_on.should eql(DateTime.new(2009, 12, 23, 21, 37))
  end
  
  it "should show the clipping properly with the to_s method" do
    
    expected =<<EOF
Book title (Name of author)
- Highlight Loc. 1942 | Added on Wednesday, December 23, 2009, 09:37 PM

This is the content.
EOF
    expected.chomp!
    
    clipping = KindleClippings::Clipping.new('Book title', 'Name of author', :Highlight, '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    
    clipping.to_s.should eql(expected)
  end

  it "should handle dates that include seconds" do
    title = 'The Clean Coder: A Code of Conduct for Professional Programmers'
    author = 'Martin, Robert C.'
    type = :Highlight
    location = '1637-1639'
    added_on = 'Friday, August 10, 2012 2:10:36 AM'
    content = 'The bottom line is that TDD works...'

    clipping = KindleClippings::Clipping.new(title, author, type, location, added_on, content)
    clipping.added_on.should == DateTime.new(2012, 8, 10, 2, 10,36)
  end

  it "should parse alternative format" do
    added_on = "Sunday, 22 January 12 22:51:04 GMT+01:00"

    clipping = KindleClippings::Clipping.new('Book title', 'Name of author', :Highlight, '1942', added_on, 'This is the content.')
    clipping.added_on.should eql(DateTime.new(2012, 01, 22, 22, 51, 04, '+1'))
  end
end
