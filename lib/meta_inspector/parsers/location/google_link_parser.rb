module MetaInspector
  module Parsers
    module Location
      class GoogleLinkParser < Base
        require "cgi"
        delegate [:parsed, :base_url]         => :@main_parser

        def initialize(main_parser)
          super(main_parser)
        end

        def locations
          loc = [{:lat => @_lat, :lng => @_lng,:type =>self.class.to_s} ] if lat && lng && lat != 0 && lng != 0 
        end

        def location
          loc = [{:lat => @_lat, :lng => @_lng,:type =>self.class.to_s} ] if lat && lng && lat != 0 && lng != 0 
        end

        def lat
          @_lat || (parse! && @_lat)
        end

        def lng
          @_lng || (parse! && @_lng)
        end

        def parse!
          links  = parsed.css('a').map { |link| link['href'] }
          if google_maps_link = links.detect { |link| /maps\.google\.com/ =~ link}
            if matches = Regexp.new(/q=(-?\d+\.\d+),(-?\d+\.\d+)/).match(google_maps_link)
              @_lng =  matches[2].to_f
              @_lat = matches[1].to_f
            end
          end
          if parsed.text.match(/google.maps.LatLng\(/)
            a = parsed.text.split(/google.maps.LatLng\(/).last.split(/\)/).first
            @_lng = a.split(/,/).last.to_f
            @_lat = a.split(/,/).first.to_f
          end

          images = parsed.css('img').map { |img| img['src']}
          if static_map_link = images.detect {|link| /maps.googleapis.com\/maps\/api\/staticmap/ =~ link}
            lat_lng = CGI::parse(URI(static_map_link).query)["center"].first.split(",")
            @_lng = lat_lng[1].to_f
            @_lat = lat_lng[0].to_f
          end
          true
        end
      end
    end
  end

end