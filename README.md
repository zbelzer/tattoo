## Tattoo

A fun little gem for adding links to text based off of regular expressions and template URLs. It is important
to note that I know very little about Tattoos and their terminology. I thought it would be a fun theme since
you're simply adding some awesomness to regular old text.

## Usage

It is important to note that the Gun works both ways, you can get at the markings in a piece of text as well
as produce a marked up version. This is why it's not a JQuery plugin.

Create some "Ink" by supplying a name and a regexp. If you want it to go somewhere, give it a `:host` and `:url` as well:
    tags = Tattoo::Ink.new(:tags, /(?:\s?#)([a-z]+)/i, :host => "example.com", :url => "/tags/:tag")

Create a gun and load up some ink:
    gun = Tattoo::Gun.new("Some #sweet tags", [tags])

The gun can either produce a 'tattoo' for you:
    gun.tattoo => "Some <a href="http://example.com/tags/sweet">#sweet</a> tags"

Or you can look at what you would have written:
    gun.look => {:tags => ["sweet"]}

The latter is useful in parsing things like tweets and saving the tags or whatnot to the database.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009 Zachary Belzer (zbelzer). See LICENSE for details.
