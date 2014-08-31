# encoding: utf-8
class A::BaseController < ApplicationController
  before_filter :authenticate_user!
  layout proc { |controller| controller.request.xhr? ? nil : "layouts/a/application" }
end
