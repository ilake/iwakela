class CommentsController < ApplicationController
  helper :all

  before_filter :check_auth, :except => :show

  def create
    @forum = params[:model].constantize.find(params[:id])
    params[:comments][:user_id] = @me.id
    @forum.comments.create(params[:comments])

    redirect_to :back
  end

end
