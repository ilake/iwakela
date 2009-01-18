class MobileController < ApplicationController
  def index
    redirect_to :action => 'home' and return if @me
  end

  def home
  end

  def list
    @records = @me.records.find(:all, :order => 'todo_time DESC', :limit => 7)
  end

  def edit_time_offset
  end

end
