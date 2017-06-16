module MetaInspector
  module Parsers
    module Location
      class Parser < Base
        require 'bigdecimal'

        delegate [:parsed, :base_url]         => :@main_parser
        
        def initialize(main_parser)
          @main_parser = main_parser
          super(main_parser)
        end

        def locations
          locations = []
          locations << get_icbm if get_icbm
          locations << get_microservice if get_microservice
          locations << get_geotag if get_geotag
          return locations.empty? ? nil : locations
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
        
    
      end
    end
  end
end