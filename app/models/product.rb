# encoding: utf-8
class Product < ActiveRecord::Base
  attr_accessible :img, :price, :title, :user_id,:visible,:avatar, :avatar_cache, :remove_avatar
  belongs_to :user
  validates_presence_of :title, :message => "产品名称不能为空"
  validates_presence_of :user_id, :message => "创建者不能为空"
  validates_presence_of :price, :message => "产品价格不能为空"
  #可见
  def visible_txt
    Setting[:visible_types][visible] rescue nil
  end
  mount_uploader :avatar, AvatarUploader
end
