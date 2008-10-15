class NamepkController < ApplicationController
  before_filter :siderbar
  before_filter :check_ip 

  def index
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

  def create_fight_methods
    @game = Game.find(params[:id]) 
    if request.post?
      @game.fight_methods.find_or_create(params[:fight_method])
    end

    @fight_method = @game.fight_methods.new
    @methods = @game.fight_methods.all(:order => 'id DESC')
    @methods_size = @methods.size
  end

  def adv_game_setting
    @game = Game.find(params[:id]) 
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
    if @method = FightMethod.find(params[:id])
      if request.post?
        if @method.update_attributes(params[:method])
          flash[:notice] = '更新成功'
          redirect_to :action => 'adv_game_setting', :id => params[:game] and return
        end
      end
      render :action => 'update_method', :game => params[:game]
    else
      redirect_to :back
    end
  end

  def update_attr
    if @attr = Attr.find(params[:id])
      if request.post?
        if @attr.update_attributes(params[:attr])
          flash[:notice] = '更新成功'
          redirect_to :action => 'adv_game_setting', :id => params[:game] and return
        end
      end
      render :action => 'update_attr', :game => params[:game]
    else
      redirect_to :back
    end
  end

  def destroy
    if method = FightMethod.find(params[:id])
      method.destroy
    end
    redirect_to :back
  end

  private
  def check_ip  
    if request.env['HTTP_X_REAL_IP'] == "59.115.204.192"  
      render :text => '阿鬼 別在玩啦！'  and return
    end  
  end 

end
