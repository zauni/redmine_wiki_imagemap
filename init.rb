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
  version '0.2.0'

  Redmine::WikiFormatting::Macros.register do
    desc "Embed image map\nUsage:\n<pre>{{imagemap(image_url)\nMap areas - everything between <map></map>\n}}</pre>"
    macro :imagemap do |obj, args, text|
      page = obj.page
      raise 'Page not found' if page.nil?

      filename = args.first
      $currentmap.nil? ? ($currentmap = 1) : ($currentmap = $currentmap + 1)

      if obj && obj.respond_to?(:attachments) && attachment = Attachment.latest_attach(obj.attachments, filename)
        imgurl = download_named_attachment_path(attachment, attachment.filename, :only_path => true)
        img = image_tag(imgurl, :alt => attachment.description, :usemap => "#map-#{$currentmap}")
      else
        raise "Attachment #{filename} not found"
      end

      return "<div style='overflow: auto; max-width: 100%;'>#{img}<map name='map-#{$currentmap}'>#{ CGI::unescapeHTML(text) }</map></div>".html_safe
    end
  end

end
