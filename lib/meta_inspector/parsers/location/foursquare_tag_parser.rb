module MetaInspector
  module Parsers
    module Location
      class FoursquareTagParser < Base
        require 'bigdecimal'
        
        delegate [:parsed, :base_url]         => :@main_parser
        
        def initialize(main_parser) 
          super(main_parser)
        end

        def location
          {lat:lat, lng:lng, type:self.class.to_s} if lat && lng && lat != 0 && lng != 0 
        end
        def lat
          @_lat || (parse! && @_lat)
        end

        def lng
          @_lng || (parse! && @_lng)
        end

        def parse!
          lat_lng = ""
          parsed.xpath("//meta[@property='playfoursquare:location:latitude']/@content").each do |attr|
            @_lat = attr.value.to_f
          end
          parsed.xpath("//meta[@property='playfoursquare:location:longitude']/@content").each do |attr|
            @_lng = attr.value.to_f
          end
          # if sp.length == 2
          #   @_lat = BigDecimal.new(sp[0])
          #   @_lng = BigDecimal.new(sp[1])
          # end

          
        end
    
      end
    end
  end
end