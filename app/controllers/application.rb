# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  include HoptoadNotifier::Catcher
  require 'ruby-debug'
  session :session_key => '_earlybirds_session_id'
  require "sanitize"

  before_filter :check_user
  before_filter :jumpback
  #before_filter :set_time_zone

  def set_time_zone
    Time.zone = @me.time_zone if @me
  end

  def check_user
    if uid = session[:uid]
      @me = User.find_by_id(uid)
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

  def user_default_sideber_option
    @census_status = session[:census] ? session[:census] : 'show'
    @number_clock_status = session[:number_clock] ? session[:number_clock] : 'show'
    @alarm_clock_status = session[:alarm_clock] ? session[:alarm_clock] : 'show'
    @sleep_button_status = session[:sleep_button] ? session[:sleep_button] : 'show'
    @last_rsp_status = session[:last_rsp] ? session[:last_rsp] : 'show'
  end

  def month_selected
    params[:date].nil? ? Time.now.month : params[:date][:month].to_i 
  end

  def year_selected
    params[:date].nil? ? Time.now.year : params[:date][:year].to_i 
  end

  def check_auth
    unless session[:uid]
      flash[:notice] = '您需要先登入喔'
      session[:original_uri] = request.request_uri
      redirect_to :controller => 'main', :action => 'login'
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

  def rescue_action_in_public(exception)
    case exception
    when ActionController::RedirectBackError
      jumpto = session[:jumpback] || {:controller => "main"}
      redirect_to jumpto
    when ActionController::RoutingError
      redirect_to home_url
    else
      super
    end
  end

end
