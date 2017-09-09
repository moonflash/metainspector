module MetaInspector
  module Location
    class YelpTagParser
      require 'bigdecimal'

      delegate [:pio, :parsed, :base_url]         => :@main_parser
        
        def initialize(main_parser) 
          super(main_parser)
          @reg = /([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {1,2}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)/
        end
        
        def location
          @_locations || parse! 
        end

        def parse!
          text = parsed.at('body').inner_text

          @_locations = []
          text.scan(@reg).each do |postcode|
            loc = pio.lookup(postcode.first) 
            ap loc.latitude if loc
            @_locations << {:lat => loc.latitude, :lng => loc.longitude, :type => self.class.to_s} if loc
          end
          @_locations unless @_locations == []
        end
      end
    end
  end
end