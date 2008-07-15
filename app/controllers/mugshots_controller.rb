class MugshotsController < ApplicationController
  helper :all

  def index
    @mugshots = Mugshot.find(:all, :conditions => ["thumbnail is null"])
  end

  def new
    @mugshot = Mugshot.new
  end

  def create
    if @me.mugshot = Mugshot.create(params[:mugshot])
      flash[:notice] = '頭像更新成功.'
      redirect_to :controller => 'user', :action => 'edit', :id => @me
    else
      render :action => :new
    end
  end
end
