# encoding: utf-8
class A::ProductsController < A::BaseController
  def index
    case params[:act]
      when 'new'
        @product = current_user.products.new(params[:product])
        respond_to do |format|
          if @product.save
            format.html { redirect_to a_product_path(@product), notice: '创建成功!' }
            format.json { render json: @product, status: :created, location: @product }
          else
            flash[:error] = "创建失败.-#{@product.errors.full_messages}"
            format.html { render action: "new" }
            format.json { render json: @product.errors, status: :unprocessable_entity }
          end
        end
      else
        if params[:submit_delall]&&params[:ids]
          Product.find(params[:ids]).each(&:destroy)
          flash[:notice] = "删除成功!"
        end
        @search = Product.search(params[:search])
        @products = @search.where(:user_id => current_user.id).order("created_at DESC").page(params[:page])
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @products }
        end
    end
  rescue Exception => ex
    throw ex
    #redirect_to(a_products_path, :notice => '操作有误,请重新操作.'+ ex.message)
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(params[:product])
    respond_to do |format|
      if @product.save
        format.html { redirect_to a_product_path(@product), notice: '创建成功!' }
        format.json { render json: @product, status: :created, location: @product }
      else
        flash[:error] = "创建失败.-#{@product.errors.full_messages}"
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @product = current_user.products.find(params[:id])
  end

  def edit
    @product = current_user.products.find(params[:id])
  end

  #更新页面
  def update
    @product = current_user.products.find(params[:id])
    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to a_product_path(@product), notice: '更新成功!' }
        format.json { head :ok }
      else
        flash[:error] = "更新失败.-#{@product.errors.full_messages}"
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #修改值
  def change_visible
    raise "Request type error!" unless request.xhr?
    @product = Product.find(params[:id])
    if @product.visible==0
      @product.increment!(:visible)
    elsif @product.visible==1
      @product.decrement!(:visible)
    end
    render :text => 'ok'
  end

  private
  # 获取页面导航相关信息的方法，供前置过滤器调用
  def page_nav_relations
    return [{:text => "产品管理", :url => a_products_path, :scope => :all},
    ], [{:text => "新增产品", :url => new_a_product_path, :scope => :all, :class => "icon icon-add"}]
  end
end
