module MetaInspector
  module Parsers
    module Location
      class MicroformatParser < Base

        delegate [:parsed, :base_url]         => :@main_parser
        
        def initialize(main_parser) 
          super(main_parser)
        end

        def location
          return {lat:lat, lng:lng, type:self.class.to_s} if lat && lng && lat != 0 && lng != 0 
        end

        def lat
          @_lat || (parse! && @_lat)
        end

        def lng
          @_lng || (parse! && @_lng)
        end

        def parse!
          t = parsed.css(".geo .latitude").text if parsed.at_css(".geo .latitude")
          g = parsed.css(".geo .longitude").text if parsed.at_css(".geo .longitude")

          if t && g
            # @_lat = BigDecimal.new(t)
            # @_lng = BigDecimal.new(g)
            @_lat = t.to_f
            @_lng = g.to_f
            return true
          end

          lt_lng_par = ""
          lt_lng_par = parsed.at(".geo").text if parsed.at_css(".geo")

          sp = lt_lng_par.split(';')
          if sp.length == 2
            # @_lat = BigDecimal.new(sp[0])
            # @_lng = BigDecimal.new(sp[1])
            @_lat = sp.first.to_f
            @_lng = sp.last.to_f
          end

        end
    
      end
    end
  end
end