class TargetsController < ApplicationController
  WEEK_OPTIONS= [['一', 1], ['二', 2], ['三', 3], ['四', 4], ['五', 5], ['六', 6], ['日', 0]]

  def target_time_week
    if request.post?
      target = @me.targets.find_or_initialize_by_week(params[:week].to_i)
      target.todo_target_time = target_time( params[:date][:hour], params[:date][:minute] )

      if target.save
        flash[:info] = "設定完成"
        redirect_to :back
      end
    else
      render :layout => false
    end
  end

  def destroy
    @me.targets.find(params[:id]).destroy
    redirect_to :back
  end
end
