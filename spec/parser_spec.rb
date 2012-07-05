# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Parser" do
  
  before(:each) do
    @parser = KindleClippings::Parser.new
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
  
  it "should should handle multiline annotations" do
    
    input =<<EOF
The Tipping Point: How Little Things Can Make a Big Difference (Malcolm Gladwell)
- Bookmark Loc. 1933 | Added on Wednesday, December 23, 2009, 09:37 PM

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut hendrerit est semper erat fringilla aliquet. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed vel urna augue, et fermentum ante. Maecenas eget arcu id eros consectetur vulputate. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vivamus ut sollicitudin orci. Donec in urna lacinia urna sodales posuere sit amet ut nulla. Duis quis quam et dolor dignissim accumsan. Vestibulum porttitor elit at dolor euismod dapibus scelerisque lacus porta. In vel egestas nunc. Curabitur dapibus iaculis enim eu mattis. Pellentesque quis justo eget ligula congue sagittis sit amet sit amet lorem. Ut augue eros, laoreet consectetur sagittis id, luctus quis dolor. Mauris porta, mauris sed gravida varius, enim enim iaculis felis, vitae blandit arcu orci sed nibh. Proin volutpat lobortis metus a dapibus. Fusce ac quam cursus lorem consequat aliquet. Nulla odio lectus, eleifend sit amet eleifend ac, eleifend quis diam. Mauris malesuada, odio eget hendrerit rhoncus, lectus odio laoreet arcu, ac mattis mi ante fringilla nibh.

Ut mauris turpis, cursus non interdum quis, porta vel augue. Pellentesque id ornare ipsum. Morbi vestibulum, purus id consequat molestie, eros lacus congue leo, a lacinia lectus velit nec augue. Aliquam erat volutpat. Cras consectetur porttitor leo sit amet pulvinar. Nunc dignissim justo non mauris eleifend tempus vel a augue. Curabitur accumsan, dui consequat consequat rhoncus, enim nisl lobortis neque, non placerat nulla sem ut leo. Vivamus turpis lacus, rhoncus vitae pellentesque ac, dignissim non lorem. Praesent ullamcorper nisi suscipit mi ornare suscipit. Maecenas pharetra urna quis ante vulputate ac congue lacus hendrerit. Nunc nunc lorem, convallis eget mollis sit amet, laoreet eu nunc.

Integer ut eros ac tellus egestas tempus placerat et arcu. Nullam porttitor est eu purus commodo tempor. Nullam varius, lacus ut porttitor fringilla, nibh turpis molestie urna, at mattis quam felis sit amet libero. Duis orci sapien, tempus nec mattis id, congue sed turpis. Aenean accumsan, lectus in malesuada blandit, felis nisl consectetur lacus, sed vehicula urna diam placerat neque. Nulla porta orci at ante elementum commodo quis vulputate neque. Aliquam quis leo sit amet lacus mollis egestas. Vivamus ac massa nec felis consectetur tincidunt. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla facilisi. Nullam non dolor nisl, eu pretium est.
EOF
    
    clipping = @parser.send(:parse_clipping, input)
    
    clipping.content.should eql("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut hendrerit est semper erat fringilla aliquet. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed vel urna augue, et fermentum ante. Maecenas eget arcu id eros consectetur vulputate. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vivamus ut sollicitudin orci. Donec in urna lacinia urna sodales posuere sit amet ut nulla. Duis quis quam et dolor dignissim accumsan. Vestibulum porttitor elit at dolor euismod dapibus scelerisque lacus porta. In vel egestas nunc. Curabitur dapibus iaculis enim eu mattis. Pellentesque quis justo eget ligula congue sagittis sit amet sit amet lorem. Ut augue eros, laoreet consectetur sagittis id, luctus quis dolor. Mauris porta, mauris sed gravida varius, enim enim iaculis felis, vitae blandit arcu orci sed nibh. Proin volutpat lobortis metus a dapibus. Fusce ac quam cursus lorem consequat aliquet. Nulla odio lectus, eleifend sit amet eleifend ac, eleifend quis diam. Mauris malesuada, odio eget hendrerit rhoncus, lectus odio laoreet arcu, ac mattis mi ante fringilla nibh.\n\nUt mauris turpis, cursus non interdum quis, porta vel augue. Pellentesque id ornare ipsum. Morbi vestibulum, purus id consequat molestie, eros lacus congue leo, a lacinia lectus velit nec augue. Aliquam erat volutpat. Cras consectetur porttitor leo sit amet pulvinar. Nunc dignissim justo non mauris eleifend tempus vel a augue. Curabitur accumsan, dui consequat consequat rhoncus, enim nisl lobortis neque, non placerat nulla sem ut leo. Vivamus turpis lacus, rhoncus vitae pellentesque ac, dignissim non lorem. Praesent ullamcorper nisi suscipit mi ornare suscipit. Maecenas pharetra urna quis ante vulputate ac congue lacus hendrerit. Nunc nunc lorem, convallis eget mollis sit amet, laoreet eu nunc.\n\nInteger ut eros ac tellus egestas tempus placerat et arcu. Nullam porttitor est eu purus commodo tempor. Nullam varius, lacus ut porttitor fringilla, nibh turpis molestie urna, at mattis quam felis sit amet libero. Duis orci sapien, tempus nec mattis id, congue sed turpis. Aenean accumsan, lectus in malesuada blandit, felis nisl consectetur lacus, sed vehicula urna diam placerat neque. Nulla porta orci at ante elementum commodo quis vulputate neque. Aliquam quis leo sit amet lacus mollis egestas. Vivamus ac massa nec felis consectetur tincidunt. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla facilisi. Nullam non dolor nisl, eu pretium est.")
  end
  
  it "should use the entire line as title if no author is available" do
    input =<<EOF
Static Code Analysis and Code Contracts 
- Note Loc. 1 | Added on Monday, August 29, 2011, 09:06 AM

This is a note.
EOF
    clipping = @parser.send(:parse_clipping, input)

    clipping.should_not be_nil
    clipping.book_title.should eql("Static Code Analysis and Code Contracts")
    clipping.author.should eql("")
  end
  
  it "should support page information" do
    input =<<EOF
Book title (Author)
- Highlight on Page 142 | Loc. 2170-74 | Added on Tuesday, July 03, 2012, 07:41 PM

Lorem ipsum dolor sit amet, consectetur adipiscing elit. In velit sem, blandit rhoncus iaculis interdum, ultrices sed sem. Nullam lacus urna, interdum eu fringilla et, fringilla id libero.
EOF
  clipping = @parser.send(:parse_clipping, input)

  clipping.should_not be_nil
  clipping.book_title.should eql("Book title")
  clipping.author.should eql("Author")
  clipping.type.should eql(:Highlight)
  clipping.added_on.should eql(DateTime.new(2012, 07, 03, 19, 41, 00))
  clipping.content.should eql("Lorem ipsum dolor sit amet, consectetur adipiscing elit. In velit sem, blandit rhoncus iaculis interdum, ultrices sed sem. Nullam lacus urna, interdum eu fringilla et, fringilla id libero.")
  clipping.page.should eql(142)

  clipping.to_s.should eql(input.rstrip)
  end
end



