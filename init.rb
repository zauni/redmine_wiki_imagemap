#
# plugins/redmine_wiki_html_util/init.rb
#
require 'redmine'
require 'open-uri'

Redmine::Plugin.register :imagemapplugin do
  name 'Redmine Wiki Imagemaps Macro'
  author 'Matthias Zaunseder'
  author_url 'http://github.com/zauni/redmine_wiki_imagemap'
  description 'Allows you to embed Imagemaps in your wiki.'
  version '0.1.0'

  Redmine::WikiFormatting::Macros.register do
    desc "Embed image map\nUsage:\n<pre>{{imagemap (image_url)\nMap areas - everything between <map></map>\n}}</pre>"
    macro :imagemap do |obj, args, text|
      page = obj.page
      raise 'Page not found' if page.nil?

      filename = args.first
      $currentmap.nil? ? ($currentmap = 1) : ($currentmap = $currentmap + 1)

      # For security, only allow insertion on protected (locked) wiki pages
      if page.protected
        result = "<div style='overflow: auto; max-width: 100%;'><img src='#{filename}' usemap='#map-#{$currentmap}' /><map name='map-#{$currentmap}'>#{ CGI::unescapeHTML(text) }</map></div>".html_safe
        return result
      else
        return "<!-- Macro removed due to wiki page being unprotected -->"
      end
    end
  end

end
