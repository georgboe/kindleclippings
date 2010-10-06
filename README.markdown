# Kindleclippings

Kindleclippings is a ruby library for parsing annotations created on your kindle.

When you make annotations on a kindle, they are saved as a file called "My Clippings.txt" under the documents folder.   
This library will parse these annotations/clippings and give you an array of ruby objects.

## Installation

To install kindleclippings just run

    % sudo gem install kindleclippings

## Usage

### Parsing

Parsing the `My Clippings.txt` file.

    require 'kindleclippings'

    parser = KindleClippings::Parser.new

    clippings = parser.parse_file('My Clippings.txt')
    clipping = clippings.last

    clipping.book_title # => "Confessions of a Public Speaker"
    clipping.author # => "Berkun  Scott"
    clipping.type # => :Highlight
    clipping.added_on # => #<DateTime: 2009-12-14T19:10:00+00:00 (353545963/144,0/1,2299161)>
    clipping.content # => "Most people say \"umm\" and \"uhh\" when they speak. These are called filler sounds ..."

The annotations can also be parsed directly.

    require 'kindleclippings'

    parser = KindleClippings::Parser.new
    clippings = parser.parse("the content you want to parse.")

### Retrieve only the information you care about

#### Annotation types

You can retrieve only the annotationstypes you care about. After parsing, you can call `highlights`, `notes` or `bookmarks` on the collection to get only annotations of that type.
 
    require 'kindleclippings'

    parser = KindleClippings::Parser.new
    clippings = parser.parse_file('My Clippings.txt')
    
    clippings.notes      # All the notes
    clippings.highlights # All the highlights
    clippings.bookmarks  # All the bookmarks

#### Author and book title

You can filter the results by author and booktitle by using the methods `by_author` and `by_book` on a `ClippingResult` object.

    require 'kindleclippings'

    parser = KindleClippings::Parser.new
    clippings = parser.parse_file('My Clippings.txt')

    clippings.by_author('Malcolm Gladwell') # All annotations for all the books by Malcolm Gladwell

    clippings.by_book('Born to Run') # All annotations for the book Born to Run

## Contributors

  * Georg Alexander Bøe
  * Masatomo Nakano
  * brokensandals