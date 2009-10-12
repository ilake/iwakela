class GoalsController < ApplicationController
  helper :all
  before_filter :check_auth

  def create
    if request.post?
      new_goal = @me.goals.create(params[:goals])
      if new_goal.errors.empty?
        notice_stickie("設定完成")
        if new_goal.choosed == -1
          render :partial => 'member/temp_goal', :locals => {:g => new_goal}
        else
          render :partial => 'goals/new_goal', :locals => {:g => new_goal, :show => params[:show] == 'true'}
        end
      else
        render :text => new_goal.errors.full_messages.join(','), :status => 400
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

  def change_goal_status 
    if request.post?
      goal = @me.goals.find(params[:id])

      unless @me.goals.find(:first, :conditions => {:name => goal.name, :status => params[:status].to_i})
        goal.change_goal_status(params[:status].to_i)
        case params[:status]
        when '0'
          render :partial => 'goals/new_goal', :locals => {:g => goal, :show => params[:show] == 'true'}
        when '1', '2'
          render :partial => 'goals/unactive_goal', :locals => {:g => goal, :show => params[:show] == 'true'}
        when '-1'
          render :nothing => true
        end
      else
        render :nothing => true
      end
    end
  end

  def delete_all
    if goal = @me.goals.find_by_id(params[:id])
      goal.goal_details.delete_all
      goal.total = goal.goal_details.be_done.sum(:value)
      goal.save!
    end
    redirect_to :back
  end

  def delete
    if goal = @me.goals.find_by_id(params[:id])
      goal.goal_details.delete_all
      goal.total = goal.goal_details.be_done.sum(:value)
      goal.save!
    end
  end
end
