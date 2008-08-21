class CallsController < ApplicationController
  helper :all

  def index
    @calls = Call.find(:all, :order => 'id DESC')
  end

  def new
    @call = Call.new
  end

  def create
    if demand = @me.demands.create(params[:call])
      if demand.errors.empty?
        redirect_to :action => 'index'
      end
    else
      redirect_to :action => 'index'
    end
  end

  def update
    @call = Call.find(params[:id])
    @call.update_attribute(:accepter_id, @me.id)
    flash[:notice] = "感謝您的幫忙"
    redirect_to :action => 'index'
  end

  def show
    @call = Call.find(params[:id])
  end
end
