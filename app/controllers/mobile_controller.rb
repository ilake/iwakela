class MobileController < ApplicationController
  before_filter :set_wap_content_type
  def index
    @text = "張"
  end

  def login
    if request.method == :post
    debugger
      if @user = User.authenticate(params[:user])
        session[:uid] = @user.id

        uri = session[:original_uri]
        session[:original_uri] = nil

        if params[:remember] == '1'
          cookies[:user_pass] = @user.gen_cookie
        else
          cookies.delete(:user_pass)
        end 
        
        redirect_to :controller => 'mobile', :action => 'index'
        #redirect_to(uri || {:controller => :member, :action => :index})
      else
        flash[:notice] = '名字或是密碼錯了喔'
      end
    end
  end

  private
  def set_wap_content_type  
    headers["Content-Type"] = "text/vnd.wap.wml; charset=iso-8859-1"
  end  
end
