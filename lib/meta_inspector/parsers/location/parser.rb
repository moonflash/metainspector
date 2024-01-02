module MetaInspector
  module Parsers
    module Location
      class Parser < Base
        require 'bigdecimal'
        require "pry"
        delegate [:pio, :parsed, :base_url]         => :@main_parser
        
        def initialize(main_parser)
          @main_parser = main_parser
          super(main_parser)
        end

        def locations
          @locations ||= get_locations
        end

        def get_locations
          locations = []
          locations << get_icbm if get_icbm
          locations << get_microservice if get_microservice
          locations << get_geotag if get_geotag
          locations << get_uk_postcode if get_uk_postcode
          locations << google_link_parser if google_link_parser
          locations << foursquare_tag_parser if foursquare_tag_parser
          locations << kolo_data_parser if kolo_data_parser
          return locations.empty? ? nil : locations.flatten.uniq
        end

        def location
          locations.first if locations
        end

        def get_icbm
          MetaInspector::Parsers::Location::ICBMParser.new(@main_parser).location
        end

        def get_microservice
          MetaInspector::Parsers::Location::MicroformatParser.new(@main_parser).location
        end

        def get_geotag
          MetaInspector::Parsers::Location::GeoTagParser.new(@main_parser).location
        end

        def get_uk_postcode
          MetaInspector::Parsers::Location::UkPostcode.new(@main_parser).location
        end

        def google_link_parser
          MetaInspector::Parsers::Location::GoogleLinkParser.new(@main_parser).location
        end

        def foursquare_tag_parser
          MetaInspector::Parsers::Location::FoursquareTagParser.new(@main_parser).location
        end
        
        def kolo_data_parser
          MetaInspector::Parsers::Location::KoloDataParser.new(@main_parser).location
        end
    
      end
    end
  end
end