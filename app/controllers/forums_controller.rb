class ForumsController < ApplicationController
  helper :all

  before_filter :check_auth, :only =>[:new, :create, :edit, :update]

  def index
    if params[:group]
      redirect_to :action => 'group_forum_list', :id => params[:group]
    else
      @forums = Forum.find_all_forum(params[:page])
    end
  end

  def group_forum_list
    if group = Group.find(params[:id])
      @forums = Forum.find_all_forum(params[:page], group.id)
      render :action => 'index', :id => group.id
    end
  end

  def new
    @forum = Forum.new
    render :action => 'new', :id => params[:id]
  end

  def create
    params[:forum][:group_id] = params[:group_id]
    if forum = @me.forums.create(params[:forum])
      if forum.errors.empty?
        redirect_to :action => 'show', :id => forum.id
      end
    else
      redirect_to :action => 'index'
    end
  end


  def show
    @forum = Forum.find(params[:id])
#    if group = @forum.group 
#      @next_forum = group.forums.find(:first, :include => :comments, :conditions => ["comments.created_at > ?", @forum.last_comment.created_at], :order => 'comments.created_at DESC')
#      @previous_forum = group.forums.find(:first, :include => :comments, :conditions => ["comments.created_at < ?", @forum.last_comment.created_at], :order => 'comments.created_at DESC')
#    else
#      @next_forum = Forum.no_group.find(:first, :include => :comments, :conditions => ["comments.created_at > ?", @forum.last_comment.created_at], :order => 'comments.created_at DESC')
#      @previous_forum = Forum.no_group.find(:first, :include => :comments, :conditions => ["comments.created_at < ?", @forum.last_comment.created_at], :order => 'comments.created_at DESC')
#    end
  end

  def edit
    @forum = @me.forums.find(params[:id])
  end

  def update
    @forum= @me.forums.find(params[:id])
    if @forum.update_attributes(params[:forum])
      flash[:notice] = '更新成功'
      redirect_to :action => 'show', :id => @forum
    else
      render :action => 'edit'
    end
  end 
end
