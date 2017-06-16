module MetaInspector
  module Parsers
    module Location
      class GeoTagParser < Base
        require 'bigdecimal'
        
        delegate [:parsed, :base_url]         => :@main_parser
        
        def initialize(main_parser) 
          super(main_parser)
        end

        def location
          {lat:lat, lng:lng} if lat && lng
        end
        def lat
          @_lat || (parse! && @_lat)
        end

        def lng
          @_lng || (parse! && @_lng)
        end

        def parse!
          lat_lng = ""
          parsed.xpath("//meta[@name='geo.position']/@content").each do |attr|
            lat_lng = attr.value
          end
          sp = lat_lng.split(';')
          if sp.length == 2
            @_lat = BigDecimal.new(sp[0])
            @_lng = BigDecimal.new(sp[1])
          end
        end
    
      end
    end
  end
end