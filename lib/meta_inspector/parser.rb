require 'nokogiri'
require 'postcodes_io'

module MetaInspector
  ##
  # Parses the document with Nokogiri.
  #
  # Delegates the parsing of the different elements to specialized parsers,
  # passing itself as a reference for coordination purposes
  #
  class Parser
    def initialize(document, options = {})
      @pio = Postcodes::IO.new
      @document        = document
      @head_links_parser = MetaInspector::Parsers::HeadLinksParser.new(self)
      @meta_tag_parser = MetaInspector::Parsers::MetaTagsParser.new(self)
      @links_parser    = MetaInspector::Parsers::LinksParser.new(self)
      @media_parser    = MetaInspector::Parsers::MediaParser.new(self)
      @location_parser = MetaInspector::Parsers::Location::Parser.new(self)
      @download_images = options[:download_images]
      @images_parser   = MetaInspector::Parsers::ImagesParser.new(self, download_images: @download_images)
      @texts_parser    = MetaInspector::Parsers::TextsParser.new(self)

      parsed           # parse early so we can fail early
    end

    extend Forwardable
    delegate [:locations]                                           => :@location_parser
    delegate [:location]                                            => :@location_parser
    delegate [:media]                                               => :@media_parser
    delegate [:url, :scheme, :host]                                 => :@document
    delegate [:meta_tags, :meta_tag, :meta, :charset]               => :@meta_tag_parser
    delegate [:links, :base_url]                                    => :@links_parser
    delegate :images                                                => :@images_parser
    delegate [:head_links, :stylesheets, :canonicals, :feeds, :feed]                       => :@head_links_parser
    delegate [:title, :best_title, :author, :best_author, :description, :best_description, :readable_text, 
              :h1, :h2, :h3, :h4, :h5, :h6]                                                => :@texts_parser

    # Returns the whole parsed document
    def parsed
      @parsed ||= Nokogiri::HTML(@document.to_s)
    end

    def pio
      @pio
    end

  end
end
