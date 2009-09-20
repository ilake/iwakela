class MessagesController < ApplicationController
  uses_tiny_mce(:options => AppConfig.message_mce_options, :only => [:new, :edit, :reply])
  helper :all
  before_filter :find_user
  # GET /messages
  # GET /messages.xml
  def index
    @messages = @user.own_messages.paginate :page => params[:page], :per_page => 10, :order => "created_at DESC", :include => [:reply, {:user => :mugshot}]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = @user.own_messages_and_reply.find(params[:message_id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = @me.leave_messages.new(:master_id => @user.id, :public => 0)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  def reply
    @message = @me.leave_messages.new(:master_id => @user.id, :message_id => params[:message_id], :public => 1)

    respond_to do |format|
      format.html { render :action => 'new' }# new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        notice_stickie('發表成功')
        #spawn do
          EbMail.deliver_message_response(@message) 
        #end

        format.html { redirect_to(messages_path(:id => @user)) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        notice_stickie('更新成功')
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url(:id => params[:user_id])) }
      format.xml  { head :ok }
    end
  end

end
