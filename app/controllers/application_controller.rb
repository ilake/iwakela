# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all

 # include HoptoadNotifier::Catcher
  require "sanitize"

  filter_parameter_logging :password
  before_filter :check_user
  before_filter :set_user_language  

  def check_user
    if uid = session[:uid]
      @me ||= User.find(uid, :include => :status)
    elsif @me = User.authenticate_by_cookie(cookies[:user_pass])
      session[:uid] = @me.id
      cookies[:user_pass] = @me.gen_cookie
    else
      session[:original_uri] = request.request_uri
      # wrong cookie
      cookies.delete(:user_pass)
    end
  end

  def target_time(hour, minute)
      now = Time.now
      Time.local(now.year, now.month, now.day, hour, minute, now.sec)
  end

  private
  def find_user
    begin
      @user ||= User.find(params[:id])
    rescue
      @user ||= @me
      redirect_to :controler => 'main', :action => 'index' and return false unless @user
    end
  end

  def month_selected
    if params[:month]
      params[:month].to_i
    elsif params[:date]
      params[:date][:month].to_i
    else
      Time.now.month
    end
  end

  def year_selected
    if params[:year]
      params[:year].to_i
    elsif params[:date]
      params[:date][:year].to_i
    else
      Time.now.year
    end
  end

  def check_auth
    unless session[:uid]
      warning_stickie('您需要先登入喔')
      session[:original_uri] = request.request_uri
      if params[:style] == 'mobile'
        redirect_to :controller => 'main', :action => 'login'
      else
        redirect_to :controller => 'main', :action => 'login'
      end
    end
  end

  def jumpback
    session[:jumpback] = session[:jumpcurrent]
    session[:jumpcurrent] = request.request_uri
  end  

  #  force the request connect from outside
#  def local_request? 
#    false 
#  end

  def set_user_language
    cookies[:language] ||= '0'
    I18n.locale = LOCALES_AVAILABLE[cookies[:language].to_i]
  end

  def user_now
    @user_now ||= @user.time_now
  end

  def user_today
    now = user_now
    @user_today ||= now.midnight
  end
end
