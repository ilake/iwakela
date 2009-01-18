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
        flash[:notice] = "變更完成"
        redirect_to :controller => 'user', :action => 'edit', :id => @me.id
      else
        flash[:notice] = "變更失敗, 可能已有人使用"
      end
    else
      @profile = @me.profile
    end
  end
  alias_method :edit_username, :edit

  def edit_profile
    if request.post?
      if @me.profile.update_attributes(params[:profile])
        flash[:notice] = "變更完成"
        redirect_to :controller => 'user', :action => 'edit', :id => @me.id
      else
        flash[:notice] = "變更失敗, 可能已有人使用"
      end
    else
      @profile = @me.profile
    end
  end

  def edit_time_shift
    if request.post?
      if @me.setting.update_attributes(params[:setting])
        flash[:notice] = "變更完成"
        redirect_to :controller => 'user', :action => 'edit', :id => @me.id
      else
        flash[:notice] = "變更失敗, 可能已有人使用"
      end
    else
      @setting = @me.setting
    end
  end

  def edit_time_offset
    if request.post?
      offset = count_time_offset(params[:date])
      if @me.setting.update_attributes(:time_offset => offset)
        flash.now[:notice] = "變更完成"
      else
        flash.now[:notice] = "變更失敗, 可能已有人使用"
      end
    else
      @setting = @me.setting
    end

    if params[:style] == 'mobile'
      render :template => 'mobile/edit_time_offset', :layout => 'mobile'
    else
      render :action => 'edit_time_offset'
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
        flash[:notice] = "變更完成"
        redirect_to :controller => 'user', :action => 'edit', :id => @user.id
      else
        flash[:notice] = "變更失敗, 密碼打錯了啦"
      end
    end
  end


  private
  def check_owner
    unless params[:id].to_i == @me.id
      flash[:notice] = "請更改自己的檔案"
      redirect_to :controller => 'main', :action => 'index'
    end
  end

  def count_time_offset(date)
    symbol = date[:plus_minus] == 'add' ? 1 : -1
    value = date[:hour].to_i + sprintf("%.2f", date[:minute].to_i/60.0).to_f
    symbol*value
  end
end
