class ForumsController < ApplicationController
  uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:new, :edit])

  helper :all

  before_filter :check_auth, :only =>[:new, :create, :edit, :update]

  def index
    if params[:group]
      redirect_to :action => 'group_forum_list', :id => params[:group]
    else
      @forums = Forum.find_all_forum(params[:page], nil, params[:category], @me)
    end
  end

  def list
    @forums = Forum.paginate :include => :user, :page => params[:page], :per_page => 20, :conditions => {:public => 2}
  end

  def group_forum_list
    if group = Group.find(params[:id])
      @forums = Forum.find_all_forum(params[:page], group.id)
      render :action => 'index', :id => group.id
    end
  end

  def new
    @forum = Forum.new
    render :action => 'new', :id => params[:id], :category => params[:category]
  end

  def create
    [:group_id, :category].each do |k|
      params[:forum][k] = params[k]
    end

    if forum = @me.forums.create(params[:forum])
      if forum.errors.empty?
        redirect_to :action => 'show', :id => forum.id
      else
        error_stickie(forum.errors.full_messages.join(','))
        redirect_to :action => 'index'
      end
    else
      redirect_to :action => 'index'
    end
  end

  def show
    @forum = Forum.find(params[:id])
  end

  def edit
    @forum = @me.forums.find(params[:id])
  end

  def destroy
    @me.forums.find(params[:id]).destroy
    redirect_to :controller => 'forums', :action => 'index'
  end

  def update
    @forum= @me.forums.find(params[:id])
    if @forum.update_attributes(params[:forum])
      notice_stickie("更新成功")
      redirect_to :action => 'show', :id => @forum
    else
      render :action => 'edit'
    end
  end 

  def update_pulic
    @forum= Forum.find(params[:id])
    if @forum.update_attributes(params[:forum])
      notice_stickie("更新成功")
      redirect_to :action => 'show', :id => @forum
    else
      render :action => 'edit'
    end
  end 
end
