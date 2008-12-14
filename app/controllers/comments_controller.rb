class CommentsController < ApplicationController
  helper :all

  before_filter :check_auth, :except => :show

  def create
    @forum = params[:model].constantize.find(params[:id])
    params[:comments][:user_id] = @me.id
    if @forum.comments.create(params[:comments]) && @forum.is_a?(Forum)
      @forum.last_comment_time = @forum.comments.last.created_at
      @forum.save
    end

    @comment = @forum.comments.last

    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

end
