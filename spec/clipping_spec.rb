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

  describe '#<=>' do
    let(:title1) { 'a title' } # < title2
    let(:title2) { 'b title' } # > title1
    let(:page1) { '27' } # > page2
    let(:page2) { '11' } # < page1
    let(:location1) { '123-133' } # < location2
    let(:location2) { '134-144' } # > location1
    let(:added1) { 'Sunday, 22 January 12 22:51:04 GMT+01:00' } # > added2
    let(:added2) { 'Sunday, 22 January 12 22:51:03 GMT+01:00' } # < added1

    let(:clipping1) {
      KindleClippings::Clipping.new(
        title1, 'author', 'type', location1, added1, 'content', page1
      )
    }

    let(:clipping2) {
      KindleClippings::Clipping.new(
        title2, 'author', 'type', location2, added2, 'content', page2
      )
    }

    it 'compares clippings by book title' do
      expect(clipping1).to be < clipping2
    end

    context 'books have same title' do
      let(:title2) { title1 }

      it 'compares clippings by page' do
        expect(clipping1).to be > clipping2
      end

      context 'clippings have same page' do
        let(:page2) { page1 }

        it 'compares clippings by location' do
          expect(clipping1).to be < clipping2
        end

        context 'clippings have same location start' do
          let(:location2) { '123-132' }

          it 'compares clippings by location end' do
            expect(clipping1).to be > clipping2
          end
        end

        context 'clippings have same location' do
          let(:location2) { location1 }

          it 'compares clippings by date added' do
            expect(clipping1).to be > clipping2
          end
        end
      end
    end
  end
end
