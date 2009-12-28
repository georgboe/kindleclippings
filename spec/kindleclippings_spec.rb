# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Kindleclippings" do
  
  before(:each) do
    @parser = KindleClippings::ClippingParser.new
  end
  
  it "should parse clippings" do
    input =<<EOF
Freakonomics Rev Ed (Steven D., Levitt)
- Highlight Loc. 1334-40 | Added on Tuesday, November 03, 2009, 09:00 PM

Listerine, for instance, was invented in the nineteenth century as a powerful surgical antiseptic. It was later sold, in distilled form, as a floor cleaner and a cure for gonorrhea. But it wasn’t a runaway success until the 1920s, when it was pitched as a solution for “chronic halitosis”—a then obscure medical term for bad breath. Listerine’s new ads featured forlorn young women and men, eager for marriage but turned off by their mate’s rotten breath. “Can I be happy with him in spite of that?” one maiden asked herself. Until that time, bad breath was not conventionally considered such a catastrophe. But Listerine changed that. As the advertising scholar James B. Twitchell writes, “Listerine did not make mouthwash as much as it made halitosis.” In just seven years, the company’s revenues rose from $115,000 to more than $8 million.
==========
Freakonomics Rev Ed (Steven D., Levitt)
- Highlight Loc. 1574-75 | Added on Wednesday, November 04, 2009, 05:26 AM

As for demand? Let’s just say that an architect is more likely to hire a prostitute than vice versa.
==========
Freakonomics Rev Ed (Steven D., Levitt)
- Highlight Loc. 1622-25 | Added on Wednesday, November 04, 2009, 05:34 AM

In the 1970s, if you were the sort of person who did drugs, there was no classier drug than cocaine. Beloved by rock stars and movie stars, ballplayers and even the occasional politician, cocaine was a drug of power and panache. It was clean, it was white, it was pretty. Heroin was droopy and pot was foggy but cocaine provided a beautiful high.
EOF
    
    result = @parser.parse(input)
    result.should_not be(nil)
    result.length.should eql(3)
    
  end
  
  it "should parse a 'My Clippings.txt' file" do
    result = @parser.parse_file(File.expand_path(File.dirname(__FILE__) + '/My Clippings.txt'))
    result.should_not be(nil)
    result.length.should eql(103)
  end
  
  it "should parse a highlight" do
    
    input =<<EOF
Last Words (George Carlin)
- Highlight Loc. 2239-40 | Added on Wednesday, December 02, 2009, 03:55 PM

Sometimes they say shoot. But they can’t kid me. Shoot is shit with two o’s.
EOF
    highlight = @parser.send(:parse_clipping, input)
    
    highlight.should_not be(nil)
    highlight.book_title.should eql('Last Words')
    highlight.author.should eql('George Carlin')
    highlight.type.should eql(:Highlight)
    highlight.added_on.should eql(DateTime.new(2009, 12, 02, 15, 55))
    highlight.content.should eql('Sometimes they say shoot. But they can’t kid me. Shoot is shit with two o’s.')
  end
  
  it "should parse a bookmark" do
    
    input =<<EOF
The Tipping Point: How Little Things Can Make a Big Difference (Malcolm Gladwell)
- Bookmark Loc. 1933 | Added on Wednesday, December 23, 2009, 09:37 PM


EOF
    bookmark = @parser.send(:parse_clipping, input)
    
    bookmark.should_not be(nil)
    bookmark.book_title.should eql('The Tipping Point: How Little Things Can Make a Big Difference')
    bookmark.author.should eql('Malcolm Gladwell')
    bookmark.type.should eql(:Bookmark)
    bookmark.added_on.should eql(DateTime.new(2009, 12, 23, 21, 37))
    bookmark.content.should eql("")
  end
  
  it "should parse a note" do
    
    input =<<EOF
The Tipping Point: How Little Things Can Make a Big Difference (Malcolm Gladwell)
- Note Loc. 1933 | Added on Wednesday, December 23, 2009, 09:37 PM

hello world
world hello
hello world
world hello
EOF
    
    note = @parser.send(:parse_clipping, input)
    
    note.should_not be(nil)
    note.book_title.should eql('The Tipping Point: How Little Things Can Make a Big Difference')
    note.author.should eql('Malcolm Gladwell')
    note.type.should eql(:Note)
    note.added_on.should eql(DateTime.new(2009, 12, 23, 21, 37))
    note.content.should eql("hello world\nworld hello\nhello world\nworld hello")
  end
  
  it "should show the clipping properly with the to_s method" do
    
    expected =<<EOF
Book title (Name of author)
- Highlight Loc. 1942 | Added on Wednesday, December 23, 2009, 09:37 PM

This is the content.
EOF
    expected.chomp!
    
    clipping = KindleClippings::Clipping.new('Book title', 'Name of author', 'Highlight', '1942', 'Wednesday, December 23, 2009, 09:37 PM', 'This is the content.')
    
    clipping.to_s.should eql(expected)
  end
end
