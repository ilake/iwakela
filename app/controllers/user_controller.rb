class UserController < ApplicationController
  helper :all
  before_filter :check_auth, :only =>[:edit, :edit_profile, :edit_password, :edit_time_shift, :edit_username, :edit_email, :edit_time_shift, :edit_time_offset]

  #before_filter :check_owner, :only => [:edit, :edit_profile, :edit_password, :edit_username]

  def list
    @users = User.find_all_users(params[:page])
    @num = User.count
  end

  def list_user_rank 
    @users = User.find_user_rank(params[:page], params[:sort])
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
  end

  def edit
    if request.post?
      if @me.update_attributes(params[:user])
        notice_stickie("設定完成")
        redirect_to :controller => 'user', :action => 'edit', :id => @me.id
      else
        @me = User.find(@me.id)
        error_stickie("設定失敗, 可能已有人使用")
      end
    end
    @targets = @me.targets.wake.find(:all, :order => 'week')
    @sleep_targets = @me.targets.sleep.find(:all, :order => 'week')
    @user = User.find(@me)
    @time_now = user_now
    @setting = @me.setting

    @wake_target_time_array = Array.new(7, @user.target_time)
    @user.targets.wake.each do |t|
      @wake_target_time_array[t.week] = t.todo_target_time
    end

    @sleep_target_time_array = Array.new(7, @user.sleep_target_time)
    @user.targets.sleep.each do |t|
      @sleep_target_time_array[t.week] = t.todo_target_time
    end
  end

  alias_method :edit_username, :edit
  def edit_profile
    if request.post?
      if @me.profile.update_attributes(params[:profile])
        notice_stickie("設定完成")
      else
        error_stickie("設定失敗, 可能已有人使用")
      end
    end
    redirect_to :controller => 'user', :action => 'edit', :id => @me.id
  end

  def edit_time_shift
    if request.post?
      if @me.setting.update_attributes(params[:setting])
        notice_stickie("設定完成")
        redirect_to :controller => 'user', :action => 'edit', :id => @me.id
      else
        error_stickie("設定失敗")
      end
    end
  end
  alias_method :edit_pri_settings, :edit_time_shift

  def edit_service_profile
    if request.post?
      service = @me.service_profiles.find_or_initialize_by_service(params[:service_profile][:service])
      service.attributes = params[:service_profile]
      if service.save
        notice_stickie("設定完成")
      else
        error_stickie("設定失敗")
      end
    end
    redirect_to :controller => 'user', :action => 'edit', :id => @me.id
  end

  def edit_time_offset
    if request.post?
      offset = count_time_offset(params[:date])
      time_offset = @me.setting.time_offset + offset 
      if @me.setting.update_attributes(:time_offset => time_offset)
        time_now = Time.now.since(@me.setting.time_offset.hours)
        notice_stickie("設定完成, 您現在的時間是<span class='w-red'>#{time_now.to_s(:date)}</span> 時間不正確還需要修正嗎? #{@template.link_to 'YES', :action => 'edit', :anchor => 'edit_time_offset'}")
      else
        error_stickie("設定失敗")
      end
    end

    if params[:style] == 'mobile'
      @time_now = Time.now.since(@me.setting.time_offset.hours)
      render :template => 'mobile/edit_time_offset', :layout => 'mobile'
    else
      redirect_to :controller => 'user', :action => 'edit', :id => @me.id
    end
  end

  def test_time
    headers["Content-Type"] = "text/javascript" #render js
    time = Time.now.since(@me.time_offset.hours)
    render :text => "alert('你校正之後現在的時間是#{time.strftime("%Y/%m/%d %H:%M")}');"
  end

  def edit_password
    if request.post?
      if @user = @me.edit_password(params[:current_user], params[:user])
        notice_stickie("設定完成")
      else
        error_stickie("設定失敗, 密碼打錯了啦")
      end
    end
    redirect_to :controller => 'user', :action => 'edit', :id => @me.id
  end

  def user_offset_time
    time_now = Time.now.since(@me.setting.time_offset.hours)
    render :text => time_now.to_s(:date)
  end

  private
  def check_owner
    unless params[:id].to_i == @me.id
      warning_stickie("請更改自己的檔案")
      redirect_to :controller => 'main', :action => 'index'
    end
  end

  def count_time_offset(date)
    symbol = date[:plus_minus] == 'add' ? 1 : -1
    value = date[:hour].to_i + sprintf("%.2f", date[:minute].to_i/60.0).to_f
    symbol*value
  end
end
