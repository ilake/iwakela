class GreatWordController < ApplicationController
  helper :all

  def new
    @great_word = GreatWord.new
    @words = @me.great_words.find(:all)
  end

  def create
    @me.great_words.create(params[:great_word])
    redirect_to :action => 'new'
  end

  def list
    @words = @me.great_words.all
  end

  def destroy
    great_word = @me.great_words.find(params[:id])
    if great_word.destroy
      redirect_to :back
    else
      flash[:notice] = '刪除失敗'
      redirect_to :action => 'list' 
    end
  end

  def edit
    @great_word = @me.great_words.find(params[:id])
  end

  def update
    @great_word = @me.great_words.find(params[:id])

    if @great_word.update_attributes(params[:great_word])
      flash[:notice] = '更新成功'
      redirect_to :action => 'new'
    else
      render :action => 'edit'
    end
  end

end
