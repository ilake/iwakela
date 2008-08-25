class GoalsController < ApplicationController
  helper :all
  def create
    if request.post?
      new_goal = @me.goals.create(params[:goals])
      if @me.save
        flash[:info] = "設定完成"
        if new_goal.choosed == -1
          render :partial => 'member/temp_goal', :locals => {:g => new_goal}
        else
          render :partial => 'member/new_goal', :locals => {:g => new_goal}
        end
      end
    else
      @record = @me.records.find(params[:id], :order => "id DESC")
      render :layout => false
    end
  end

  def update 
    goals = @me.goals
    if params[:item]
      params[:item].each do |id, attr|
          goals.find(id.to_i).update_attributes(:choosed => attr[:choosed].to_i,
                                                :done => !attr[:done].to_i.zero?,
                                                :comment => attr[:comment],
                                                :rank => attr[:rank])
      end
    end

    record_goal = render_to_string :partial => "user_records_goal"
    comment_goal = render_to_string :partial => "user_comment_goal"
    @me.records.find(params[:id]).update_attributes(:goal => record_goal, :com_goal => comment_goal)

    redirect_to :controller => 'member', :action => 'list'
  end

  def update_tmp_goal
    goals = @me.goals.temp
    if params[:item]
      params[:item].each do |id, attr|
          goals.find(id.to_i).update_attributes(:choosed => -1,
                                                :done => false,
                                                :comment => attr[:comment],
                                                :rank => attr[:rank])
      end
    end
    redirect_to :controller => 'member', :action => 'list'
  end

  def destroy
    @me.goals.find(params[:id]).destroy
    render :nothing => true
  end
end
