class MainController < ApplicationController
  require 'rss/2.0'
  require 'open-uri'
  layout "application"
  helper :all

  #before_filter :user_default_sideber_option, :only => [:index]

  def index
    @records = Record.find_all_wake_up_today(params[:page])

    @user = @records[0].user if @records[0]
    
    @user ||= User.first
    records = @user.records.wake.find(:all, :order => 'todo_time DESC', :limit => 7, :conditions => ["todo_time < ?", Time.now ]) if @user
    @time = record_to_string(records) if records
  end

  def register
    if request.post?
      @user = User.new(params[:user])

#      if @user.yahoo_userhash != nil
#        @user.password_hash = "000" 
#        @user.password_salt = "000"
#      end

      if @user.save
        #User.send_confirm_email(@user.email)
        #notice_stickie("註冊成功了, 確認信已寄出, 請前往信箱確認開通帳號")
        notice_stickie("註冊成功了")
        redirect_to :controller => 'main',:action => 'index'
      end
    end
  end

  def login
    if request.method == :post
      if @user = User.authenticate(params[:user])
        if @user.errors.empty?
          reset_session
          session[:uid] = @user.id

          uri = session[:original_uri]
          session[:original_uri] = nil

          if params[:remember] == '1'
            cookies[:user_pass] = @user.gen_cookie
          else
            cookies.delete(:user_pass)
          end 

          if params[:style] == 'mobile'
            redirect_to :controller => 'mobile', :action => 'home' and return
          else
            redirect_to :controller => 'main', :action => 'index' and return
          end
        else
          flash[:info] = "您的email還沒經過認證 #{@template.link_to t('site.resend_confirm'), :controller => 'main', :action => 'resend_confirm'}"

          error_stickie("您的email還沒經過認證 #{@template.link_to t('site.resend_confirm'), :controller => 'main', :action => 'resend_confirm'}, 如果您的帳號當初是亂填的, 請來信iwakela@gmail.com跟站長要求更正 ")
        end
      else
        error_stickie('帳號或是密碼錯了')
      end
    end

    if params[:style] == 'mobile'
      render :template => 'mobile/login', :layout => 'mobile' and return
    end
  end

  def yahooLogin
    ya = YahooBbAuth.new()
    redirect_to ya.get_auth_url('', true)
  end

  def yahooAuth
    ya = YahooBbAuth.new()
    userhash = params[:userhash]
    if !ya.verify_sig(request.request_uri)
      redirect_to :controller => :error
      return
    end

    @user = User.find_by_yahoo_userhash(userhash)

    if @user == nil
      @user = User.new(:yahoo_userhash => userhash)
      render :action => 'register'
    else
      session[:uid] = @user.id
      redirect_to :action => "index"
    end
  end

  def logout
    cookies.delete(:user_pass)
    reset_session
    notice_stickie("您已經登出")

    if params[:style] == 'mobile'
      redirect_to :controller => 'mobile', :action => 'index'
    else
      redirect_to :controller => 'main', :action => 'index'
    end
  end

  def forget_password
    if request.post?
      if user = User.send_reset_email(params[:user][:email])
        flash[:info] = "密碼重設的信件已經寄到您的信箱 #{user.email}"
        notice_stickie("密碼重設的信件已經寄到您的信箱 #{user.email}")
      else
        warning_stickie("沒有這個人: #{params[:email]}")
      end
    end

    if params[:style] == 'mobile'
      @style = 'mobile'
      render :action => 'forget_password', :layout => 'mobile'
    else
      render :action => 'forget_password'
    end
  end

  def resend_confirm
    if request.post?
      if user = User.send_confirm_email(params[:user][:email])
        flash[:info] = "帳號確認的信件已經寄到您的信箱 #{user.email}"
        notice_stickie("帳號確認的信件已經寄到您的信箱 #{user.email}")
      else
        warning_stickie("沒有這個人: #{params[:email]}")
      end
    end

    if params[:style] == 'mobile'
      @style = 'mobile'
      render :action => 'resend_confirm', :layout => 'mobile'
    else
      render :action => 'resend_confirm'
    end
  end

  def reset_password
    case request.method
    when :post
      if User.reset_password(session[:uid], params[:user][:password], params[:user][:password_confirmation])
        notice_stickie("變更成功")
        redirect_to :controller => "main", :action => "index"
      else
        error_stickie("變更失敗")
      end
    when :get
      if user = User.check_reset_code(params[:reset_code])
        session[:uid] = user.id
        cookies[:user_pass] = user.gen_cookie
      end
    end
  end

  def confirm_email
    if request.get?
      if user = User.check_confirm_email_code(params[:confirm_code])
        notice_stickie("帳號已開通, 已可登入")
        redirect_to :controller => "main", :action => "index"
      end
    end
  end

  def search
    case params[:search_item][:search_type].to_i
    when 0
      @users = User.find_by_contents("*#{params[:query]}*", :page =>params[:page], :per_page => 20)
      warning_stickie("查無此人") if @users.empty?
      render :template => 'user/list'
    when 1
      @records = Record.find_by_contents("*#{params[:query]}*", :page =>params[:page], :per_page => 20)
      warning_stickie("沒有這樣的日誌") if @records.empty?
      render :template => 'shared/search'
    end
  end

  def test 
  end

  def ajax
    render :json => {:name => 'lake'}.to_json
  end

  def record_to_string(records)
    time = Record.time_to_string(records, "todo_time")
    return time
  end

  def language
    #0是繁体 1是简体
    cookies[:language] = params[:type] == 'tradition' ? '0' : '1'
    if request.env["HTTP_REFERER"]
      redirect_to :back
    else
      redirect_to :controller => 'main', :action => 'index'
    end
  end
end
