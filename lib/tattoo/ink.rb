module Tattoo
  DEFAULT_HOST = "www.example.com"
  DEFAULT_MARK_IDENTIFIER = "#"
  DEFAULT_TOKEN = "id"

  class Ink
    attr_reader :name

    def initialize(name, regexp, opts={})
      @name = name.to_sym
      @regexp = regexp

      options = opts.dup
      @prefix = options.delete(:prefix) || DEFAULT_MARK_IDENTIFIER
      @token = options.delete(:token) || DEFAULT_TOKEN
      @host = options.delete(:host) || DEFAULT_HOST
      @url = options.delete(:url).to_s
      @attributes = options
    end

    def mark(marking, text)
      text.gsub(/#{@prefix}#{marking}/, link_tag_for(marking))
    end

    def find_markings(text)
      text.scan(/#{prefix_regexp}#{@regexp}/).flatten
    end

    private
    def prefix_regexp
      self.class.create_prefix_regexp(@prefix)
    end

    def link_tag_for(tag)
      attributes = @attributes.map {|k, v| "#{k}=\"#{v}\""}.join(' ')
      %{<a href="#{url_for(tag)}" #{attributes}>#{@prefix}#{tag}</a>}
    end

    def url_for(tag)
      tag_url = @url.gsub(/:#{@token}/, tag)
      URI.join("http://#{@host}", tag_url).to_s
    end

    def self.create_prefix_regexp(prefix)
      /(?:\s?#{prefix})/
    end
  end
end
