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
end
