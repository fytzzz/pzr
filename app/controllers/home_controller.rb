# encoding: utf-8
class HomeController < ApplicationController
  layout proc { |controller| controller.request.xhr? ? nil : "layouts/main" }
  #首页
  def index
    links = Article.portal_artcles
    @menus = getMenus(links)
    @search = Product.search(params[:search])
    @products = @search.order("created_at DESC").page(params[:page]).per(9)
    respond_to do |format|
      format.html
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
