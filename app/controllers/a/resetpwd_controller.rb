#encoding:utf-8
class A::ResetpwdController < A::BaseController
  def index
    pwd = params[:pwd]
    cpwd = params[:cpwd]
    unless (pwd ==nil || cpwd==nil || pwd !=cpwd)
        result = User.find(1).reset_password!(pwd,cpwd)
        p result ,"reset password!"
        if(result)
          flash[:notice] = "修改密码成功！"
        else
          flash[:notice] = "修改密码失败！"
        end
    end
  rescue Exception => ex
      redirect_to "/a",:notice => "更新密码失败！"
  end
end
