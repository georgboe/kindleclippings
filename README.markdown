# Kindleclippings

Kindleclippings is a ruby library for parsing annotations created on your kindle.

When you make annotations on a kindle, they are saved as a file called "My Clippings.txt" under the documents folder.   
This library will parse these annotations/clippings and give you an array of ruby objects.

## Installation

Kindleclippings is hosted on Gemcutter. If *gemcutter.org* is not among your sources when you run `gem sources`, you'll need to install gemcutter first.

    % sudo gem install gemcutter
    % sudo gem tumble

To install kindleclippings just run this command.

    % sudo gem install kindleclippings

## Usage

    require 'kindleclippings'

    parser = KindleClippings::ClippingParser.new

    clippings = parser.parse_file('My Clippings.txt')
    clipping = clippings.last

    clipping.book_title # => "Confessions of a Public Speaker"
    clipping.author # => "Berkun  Scott"
    clipping.type # => :Highlight
    clipping.added_on # => #<DateTime: 2009-12-14T19:10:00+00:00 (353545963/144,0/1,2299161)>
    clipping.content # => "Most people say \"umm\" and \"uhh\" when they speak. These are called filler sounds ..."
