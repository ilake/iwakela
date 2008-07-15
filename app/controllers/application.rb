# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  require 'ruby-debug'
  session :session_key => '_earlybirds_session_id'
  require "sanitize"

  before_filter :check_user
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
end
