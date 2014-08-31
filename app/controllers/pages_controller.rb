class PagesController < ApplicationController
  layout proc { |controller| controller.request.xhr? ? nil : "layouts/main" }
  def show
    p params
    links = Article.portal_artcles
    @menus = getMenus(links)
    @page  = Article.find_by_id(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @page }
    end
  end
  private
  def getMenus(links)
    menus =  Hash.new {|hash, key| hash[key] = []}
    links.each_with_index do |link, i|
      menus[link.category_id] << link
    end
    menus
  end
end
