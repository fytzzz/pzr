# encoding: utf-8
class Article < ActiveRecord::Base
  attr_accessible :title,:content,:permalink,:user_id,:permalink,:category_id,:visible

  validates_presence_of :title, :message => "页面标题不能为空"
  validates_presence_of :content, :message => "页面内容不能为空"
  #validates_presence_of :permalink, :message => "页面链接不能为空"
  validates_presence_of :user_id, :message => "创建者不能为空"
  #validates_uniqueness_of :permalink, :message => "页面链接标识不能重复"
  #可见的页面
  scope :visible_articles, where("articles.visible = '1'").order("created_at ASC")
  #首页链接
  scope :portal_artcles, select("id,title,category_id").visible_articles.where("articles.category_id in (1,2,3,4,5)")
  #创建者
  belongs_to :user

  #分类
  def category_txt
    Setting[:category_types][category_id] rescue nil
  end

  #可见
  def visible_txt
    Setting[:visible_types][visible] rescue nil
  end

  #分类选项
  def self.selected_categories
    {'' => "==选择分类=="}.merge(Setting[:category_types]).invert
  end
end
