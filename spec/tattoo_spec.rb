require File.dirname(__FILE__) + "/spec_helper"

TAG_REGEXP = /([a-z][a-z\-_0-9]+)/i
USER_REGEXP = /([a-z\-\._0-9]+)/i

module Tattoo
  describe Gun do
    describe "single marking" do
      before do
        @tags = [Ink.new(:tags, TAG_REGEXP)]
      end

      it "should find leading tag" do
        text = "#foo"
        gun = Gun.new(text, @tags)
        gun.look[:tags].should == ["foo"]
      end

      it "should find tag between words" do
        text = "lorem #foo ipsum"
        gun = Gun.new(text, @tags)
        gun.look[:tags].should == ["foo"]
      end

      it "should find tag with dashes" do
        text = "lorem #foo-bar ipsum"
        gun = Gun.new(text, @tags)
        gun.look[:tags].should == ["foo-bar"]
      end

      it "should find tag with underbar words" do
        text = "lorem #foo_bar ipsum"
        gun = Gun.new(text, @tags)
        gun.look[:tags].should == ["foo_bar"]
      end

      it "should find tag with numbers" do
        text = "lorem #foo23 ipsum"
        gun = Gun.new(text, @tags)
        gun.look[:tags].should == ["foo23"]
      end

      it "should not find tag starting with number" do
        text = "lorem #23foo ipsum"
        gun = Gun.new(text, @tags)
        gun.look[:tags].should be_empty
      end

      it "should find tags next to eachother" do
        text = "#foo #bar"
        gun = Gun.new(text, @tags)
        gun.look[:tags].should == ["foo", "bar"]
      end

      it "should find multiple tags" do
        text = "lorem #foo ipsum #bar"
        gun = Gun.new(text, @tags)
        gun.look[:tags].should == ["foo", "bar"]
      end

      it "should find tags next to non word characters" do
        text = "[#bar]"
        gun = Gun.new(text, @tags)
        gun.look[:tags].should == ["bar"]
      end
    end

    describe "prefixes" do
      before do
        @tags = [Ink.new(:tags, TAG_REGEXP), Ink.new(:users, USER_REGEXP, :prefix => "@")]
      end

      it "should find all markings" do
        text = "#foo @bar"
        gun = Gun.new(text, @tags)
        gun.look[:tags].should == ["foo"]
        gun.look[:users].should == ["bar"]
      end
    end

    describe "tattoo" do
      before do
        @tags = Ink.new(:tags, TAG_REGEXP)
      end

      it "should use host" do
        tags = Ink.new(:tags, TAG_REGEXP, :host => "example.com")

        gun = Gun.new("#foo", [tags])
        gun.tattoo.should == '<a href="http://example.com">#foo</a>'
      end

      it "should substitute :id with tag" do
        tags = Ink.new(:tags, TAG_REGEXP, :host => "example.com", :url => "/tags/:id")
        gun = Gun.new("#foo", [tags])
        gun.tattoo.should == '<a href="http://example.com/tags/foo">#foo</a>'
      end
      
      it "should substitute :tag with tag" do
        tags = Ink.new(:tags, TAG_REGEXP, :host => "example.com", :url => "/tags/:tag", :token => "tag")
        gun = Gun.new("#foo", [tags])
        gun.tattoo.should == '<a href="http://example.com/tags/foo">#foo</a>'
      end

      it "should decorate as substitution" do
        tags = Ink.new(:tags, TAG_REGEXP, :host => "example.com", :url => "/tags/:id")
        gun = Gun.new("lorem #foo ipsum", [tags])
        gun.tattoo.should == 'lorem <a href="http://example.com/tags/foo">#foo</a> ipsum'
      end

      it "should consider other options html attributes" do
        tags = Ink.new(:tags, TAG_REGEXP, :host => "example.com", :name => "some name")
        gun = Gun.new("#foo", [tags])
        gun.tattoo.should == '<a href="http://example.com" name="some name">#foo</a>'
      end
    end
  end
end
