module Tattoo
  DEFAULT_HOST = "www.example.com"
  DEFAULT_MARK_IDENTIFIER = "#"

  class Ink
    attr_accessor :name, :regexp

    def initialize(name, regexp, opts={})
      @name = name.to_sym
      @regexp = regexp

      options = opts.dup
      @identifier = options.delete(:identifier) || DEFAULT_MARK_IDENTIFIER
      @identifier_regexp = self.class.create_identifier_regexp(@identifier)
      @host = options.delete(:host) || DEFAULT_HOST
      @url = options.delete(:url).to_s
      @attributes = options
    end

    def mark(marking, text)
      text.gsub(/#{@identifier}#{marking}/, link_tag_for(marking))
    end

    def find_markings(text)
      text.scan(/#{@identifier_regexp}#{@regexp}/).flatten
    end

    private
    def link_tag_for(tag)
      attributes = @attributes.map {|k, v| " #{k}=\"#{v}\""}
      %{<a href="#{url_for(tag)}"#{attributes}>#{@identifier}#{tag}</a>}
    end

    def url_for(tag)
      tag_url = @url.gsub(/:tag/, tag)
      URI.join("http://#{@host}", tag_url).to_s
    end

    def self.create_identifier_regexp(identifier)
      /(?:\s?#{identifier})/
    end
  end
end
