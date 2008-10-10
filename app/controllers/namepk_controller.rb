class NamepkController < ApplicationController
  before_filter :siderbar

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
    @fighter1 = Fighter.new(params[:game][:name1], @game)
    @fighter2 = Fighter.new(params[:game][:name2], @game)

    @game.attributes = params[:game]

    Game.increment_counter(:num, @game.id)
    Game.increment_counter(:today_num, @game.id)

    @attack_round = @game.fighter_round(@fighter1, @fighter2)
    render :action => :fight
  end

  def siderbar
    @new_games = Game.all(:order => 'id DESC', :limit => 5)
  end

end
