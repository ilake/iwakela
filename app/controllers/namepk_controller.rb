class NamepkController < ApplicationController
  before_filter :check_user
  before_filter :siderbar
  before_filter :check_ip 
  before_filter :check_code, :only => [:create_fight_methods, :adv_game_setting, :update_method, :update_attr, :update]

  def index
    @games = Game.find_hottest(params[:page], 20, 'games.today_num')
  end

  def list
    @games = Game.find_hottest(params[:page])
  end

  def new
    @game = Game.new
  end

  def create
    if @game = Game.create(params[:game])
      if @game.errors.empty?
        redirect_to :action => 'create_fight_methods', :id => @game.id and return
      end
    end
    render :action => 'new'
  end

  def edit
    @game = Game.find(params[:id]) 
  end

  def update
    if @game.update_attributes(params[:game])
      flash[:info] = '修改成功'
      redirect_to :action => 'create_fight_methods', :id => @game.id
    else
      flash[:info] = '修改失敗'
      render :action => 'edit'
    end
  end

  def create_fight_methods
    if request.post?
      @game.fight_methods.find_or_create(params[:fight_method]) 
      flash.now[:info] = '新增成功'
    end

    @fight_method = @game.fight_methods.new
    @methods = @game.fight_methods.all(:order => 'id DESC')
    @methods_size = @methods.size
  end

  def adv_game_setting
    if request.post?
      if params[:fight_method]
        @game.fight_methods.find_or_create(params[:fight_method])
      elsif params[:attr]
        @game.attrs.find_or_create(params[:attr])
      end
    end

    @fight_method = @game.fight_methods.new
    @attr = @game.attrs.new
    @methods = @game.fight_methods.all(:order => 'id DESC')
    @attrs = @game.attrs.all(:order => 'id DESC')
    @methods_size = @methods.size
  end

  def fight
    @game = Game.find(params[:id])
  end

  def do_fight
    @game = Game.find(params[:id])
    if params[:game]
      @fighter1 = Fighter.new(params[:game][:name1], @game)
      @fighter2 = Fighter.new(params[:game][:name2], @game)

      @game.attributes = params[:game]

      Game.increment_counter(:num, @game.id)
      Game.increment_counter(:today_num, @game.id)

      @attack_round = @game.fighter_round(@fighter1, @fighter2)
      render :action => :fight
    else
      redirect_to :action => 'fight', :id => @game.id
    end
  end

  def siderbar
    @new_games = Game.all(:order => 'id DESC', :limit => 5)
  end

  def talks
    @game = Game.find(params[:id])
    @talk = Talk.new
    if params[:talk]
      @talk = @game.talks.create(params[:talk])
    end

    @talks = @game.talks.paginator(params[:page])
  end

  def update_method 
    if @method = @game.fight_methods.find(params[:method_id])
      if request.post?
        if @method.update_attributes(params[:method])
          flash[:notice] = '更新成功'
          redirect_to :action => 'adv_game_setting', :id => params[:id] and return
        end
      end
      render :action => 'update_method', :id => params[:id]
    else
      redirect_to :back
    end
  end

  def update_attr
    if @attr = @game.attrs.find(params[:attr_id])
      if request.post?
        if @attr.update_attributes(params[:attr])
          flash[:notice] = '更新成功'
          redirect_to :action => 'adv_game_setting', :id => params[:id] and return
        end
      end
      render :action => 'update_attr', :game => params[:id]
    else
      redirect_to :back
    end
  end

#  def destroy
#    if method = FightMethod.find(params[:id])
#      method.destroy
#    end
#    redirect_to :back
#  end

  private
  def check_ip  
    if request.remote_ip == "59.115.204.192"  
      render :text => '阿鬼 別在玩啦！'  and return
    end  
  end 

  def check_code
    @game = Game.find(params[:id]) 
    session[:code] = params[:pass_code] if params[:pass_code]
    @pass_code = session[:code] 
    if request.post? && @game.pass_code != @pass_code
      flash[:info] = '密碼錯啦' 
      redirect_to :back and return 
    end
  end

end
