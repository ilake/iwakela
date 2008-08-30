class UserController < ApplicationController
  helper :all
  before_filter :check_auth, :only =>[:edit]

  #before_filter :check_owner, :only => [:edit, :edit_profile, :edit_password, :edit_username]

  def list
    @users = User.find_all_users(params[:page])
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
    debugger
    unless params[:id].to_i == @me.id
      flash[:notice] = "請更改自己的檔案"
      redirect_to :controller => 'main', :action => 'index'
    end
  end
end
