class MainController < ApplicationController
  #require "sparklines"
  layout "application"
  helper :all

  #before_filter :user_default_sideber_option, :only => [:index]

  def index
    @records = Record.find_all_wake_up_today(params[:page])

    @user = User.find(:first, :joins => [:status], :order => 'statuses.average', :conditions => ["statuses.num > ? AND statuses.last_record_created_at > ? AND users.target_time_now is not NULL", 7, Time.now.ago(3.days)])
    
    @user ||= User.first
    records = @user.records.wake.find(:all, :order => 'id DESC', :limit => 10, :conditions => ["todo_time < ?", Time.now ])
    @time = record_to_string(records)
  end

  def register
    if request.post?
      @user = User.new(params[:user])

      if @user.yahoo_userhash != nil
        @user.password_hash = "000" 
        @user.password_salt = "000"
      end

      if @user.save
        flash[:info] = '註冊成功了'
        session[:uid] = @user.id
        redirect_to :controller => 'member',:action => 'index'
      end
    end
  end

  def login
    if request.method == :post
      if @user = User.authenticate(params[:user])
        session[:uid] = @user.id

        uri = session[:original_uri]
        session[:original_uri] = nil

        if params[:remember] == '1'
          cookies[:user_pass] = @user.gen_cookie
        else
          cookies.delete(:user_pass)
        end 
        
        redirect_to :controller => 'main', :action => 'index'
        #redirect_to(uri || {:controller => :member, :action => :index})
      else
        flash[:notice] = '名字或是密碼錯了喔'
      end
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
    flash[:info] = '您已經登出'

    redirect_to :controller => 'main', :action => 'index'
  end

  def forget_password
    return unless request.post?
    if user = User.send_reset_email(params[:user][:email])
      flash[:info] = "密碼重設的信件已經寄到您的信箱 #{user.email}"
    else
      flash[:info] = "沒有這個人: #{params[:email]}"
    end
  end

  def reset_password
    case request.method
    when :post
      if User.reset_password(session[:uid], params[:user][:password], params[:user][:password_confirmation])
        flash[:info] = "變更成功"
        redirect_to :controller => "main", :action => "index"
      else
        flash[:info] = "變更失敗"
      end
    when :get
      if user = User.check_reset_code(params[:reset_code])
        session[:uid] = user.id
        cookies[:user_pass] = user.gen_cookie
      end
    end
  end

  def search
    case params[:search_item][:search_type].to_i
    when 0
      @users = User.find_by_contents("*#{params[:query]}*", :page =>params[:page], :per_page => 20)
      flash[:info] = "查無此人" if @users.empty?
      render :template => 'user/list'
    when 1
      @records = Record.find_by_contents("*#{params[:query]}*", :page =>params[:page], :per_page => 20)
      flash[:info] = "沒有這樣的日誌" if @records.empty?
      render :template => 'shared/search'
    end
  end

  def test
  end

  def record_to_string(records)
    time = Record.time_to_string(records, "todo_time")
    return time
  end

  def language
    #1是繁体 0 是简体
    cookies[:language] = params[:type] == 'tradition' ? '1' : '0'
    if request.env["HTTP_REFERER"]
      redirect_to :back
    else
      redirect_to :controller => 'main', :action => 'index'
    end
  end
end
