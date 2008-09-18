class GreatWordController < ApplicationController
  helper :all

  def new
    @great_word = GreatWord.new
    @words = GreatWord.all
  end

  def create
    @me.great_words.create(params[:great_word])
    redirect_to :action => 'new'
  end

  def edit
    @great_word = GreatWord.find(params[:id])
  end

  def update
    @great_word = GreatWord.find(params[:id])

    if @great_word.update_attributes(params[:great_word])
      flash[:notice] = '更新成功'
      redirect_to :action => 'new'
    else
      render :action => 'edit'
    end
  end
end
