class MugshotsController < ApplicationController
  helper :all

  def index
    @mugshots = Mugshot.find(:all, :conditions => ["thumbnail is null"])
  end

  def new
    @mugshot = Mugshot.new
  end

  def create
    if params[:id]
      @group = Group.find(params[:id])
      if @group.mugshot = Mugshot.create(params[:mugshot])
        notice_stickie('頭像更新成功')
        redirect_to :controller => 'groups', :action => 'edit', :id => @group
      else
        render :action => :new
      end
    else
      if @me.mugshot = Mugshot.create(params[:mugshot])
        notice_stickie('頭像更新成功')
        redirect_to :controller => 'user', :action => 'edit', :id => @me
      else
        render :action => :new
      end
    end
  end

end
