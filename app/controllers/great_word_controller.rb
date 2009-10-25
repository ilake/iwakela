class GreatWordController < ApplicationController
  helper :all
  before_filter :check_auth, :except => :index

  def index
    @words = GreatWord.paginate :page => params[:page],
                       :per_page => 20,
                       :include => :user,
                       :order => "id DESC"
  end

  def new
    @great_word = GreatWord.new
    @words = @me.great_words.find(:all)
  end

  def create
    @words = @me.great_words.find(:all)

    if @great_word = @me.great_words.create(params[:great_word])
      if @great_word.errors.empty?
        notice_stickie('新增成功')
        redirect_to :action => 'new' and return
      end
    end 

    render :action => 'new'
  end

  def list
    @words = @me.great_words.all
  end

  def destroy
    if @me && @me.id == ADMIN_ID
      great_word = GreatWord.find(params[:id])
    else
      great_word = @me.great_words.find(params[:id])
    end
    if great_word.destroy
      redirect_to :back
    else
      error_stickie('刪除失敗')
      redirect_to :action => 'list' 
    end
  end

  def edit
    @great_word = @me.great_words.find(params[:id])
  end

  def update
    @great_word = @me.great_words.find(params[:id])

    if @great_word.update_attributes(params[:great_word])
      notice_stickie('更新成功')
      redirect_to :action => 'new'
    else
      render :action => 'edit'
    end
  end

end
