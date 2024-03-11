require 'fastimage'

module MetaInspector
  module Parsers
    class MediaParser < Base
      delegate [:parsed, :base_url, :meta] => :@main_parser

      include Enumerable

      def initialize(main_parser, options = {})
        super(main_parser)
      end

      def media
        self
      end

      def video
        youtube || vimeo || guardian || facebook || twitter || og_mp4 || any_youtube
      end

      def any_youtube
        video = parsed.xpath("//iframe").select{|a|a.to_s.include?("youtube.com")}
        @media = video.first.to_s.gsub("data-src=", "src=") unless video.empty?
      end

      def youtube
        return unless uri.host.include?("youtube.com")
        video = CGI::parse(uri.query)["v"]
        if uri.query && CGI::parse(uri.query)["v"]
          url = "https://www.youtube.com/embed/#{video.first}"
          @media ||= "<iframe width='560' height='315' src='#{url}' frameborder='0' allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share' allowfullscreen></iframe>"
        end
      end

      def vimeo
        return unless uri.host.include?("vimeo.com") && uri.path.gsub(/^\//,'').to_i != 0
        if uri.path && CGI::parse(uri.path)["v"]
          video_id = uri.path.gsub(/^\//,'').to_i
          @media = "<iframe src='https://player.vimeo.com/video/#{video_id}?color=a9aaab&title=0&byline=0&portrait=0&badge=0' width='640' height='360' frameborder='0'  allowfullscreen></iframe>"
        end
      end

      def guardian
        return unless uri.host.include?("www.theguardian.com")
        video = parsed.search('//source').select{|v|v.attr('type') == "video/mp4"}
        unless video.empty?
          src = video.first.attr("src")
          @media = "<video autoplay width='100%' height='100%' controls><source src='#{src}' type='video/mp4'></video>"
        end
      end

      def facebook
        return unless uri.host.include?(".facebook.com") && uri.path.include?("/videos/")
        src = CGI::escape(base_url.split("?")[0])
        @media = "<iframe src='https://www.facebook.com/plugins/video.php?href=#{src}' width='560' height='315' style='border:none;overflow:hidden' scrolling='no' frameborder='0' allowTransparency='true' allowFullScreen='true'></iframe>"
      end

      def twitter
        return unless uri.host.include?("twitter.com")
        suggested_img = meta['og:video:url']
        height = meta['og:video:height'] || '400px'
        src = URL.absolutify(suggested_img, base_url) if suggested_img
        @media = "<iframe width='100%' height='#{height}' src='#{src}' frameborder='0' allowfullscreen></iframe>"
      end

      def og_mp4

        src = meta['og:video']
        height = meta['og:video:height']
        return unless src && src.include?(".mp4")
        @media ||= "<video autoplay width='100%' height='100%' controls><source src='#{src}' type='video/mp4'></video>"

      end

      private
      def uri
        URI(base_url)
      end

    end
  end
end
