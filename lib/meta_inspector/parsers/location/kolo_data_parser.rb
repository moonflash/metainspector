module MetaInspector
  module Parsers
    module Location
      class KoloDataParser < Base
        require 'bigdecimal'
        
        delegate [:parsed, :base_url]         => :@main_parser
        
        def initialize(main_parser) 
          super(main_parser)
        end

        def location
          @loc = []
          parse!
          @loc
        end

        def lat_lng(data)
          {
            lat: BigDecimal(data.split(',')[0]), 
            lng: BigDecimal(data.split(',')[1]),
            type:self.class.to_s
          }
        end

        def parse!
          parsed.css("img[name='kolo-map']").each do |img|
            img['data-kolo-lat-lng'].split(';').each do |ll|
              @loc << lat_lng(ll)
            end
          end

          parsed.css("div[name='kolo-map']").each do |img|
            img['data-kolo-lat-lng'].split(';').each do |ll|
              @loc << lat_lng(ll)
            end
          end
        end
      end
    end
  end
end