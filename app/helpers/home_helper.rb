#encoding: utf-8
module HomeHelper
  def menu_link_tag(links)
       lis = []
       links.each do |link|
         lis << "<li data-id=#{link.id}>#{link.title}</li>"
       end
       html = "<ul>" + lis.join("") + "</ul>"
       html.html_safe
  rescue
    "<ul></ul>".html_safe
  end

  def footer_link_tag(links)
     alinks = []
     links.each do |link|
       alinks << "<a href='##' data-id=#{link.id}>#{link.title}</a>"
     end
     html = alinks.join
     html.html_safe
  rescue
    ""
  end
end
