class TinyMcePhotosController < ApplicationController
  before_filter :check_auth
  skip_before_filter :verify_authenticity_token, :only => :create

  def index
    @photos = TinyMcePhoto.paginate :page => params[:page], :order => "created_at DESC", :conditions => ['user_id = ?', @me.id], :per_page => 10
    render :update do |page|
      page.replace_html :dynamic_images_list, :partial => 'photo_list', :locals => { :photos => @photos }
    end
  end

  def create
    @photo = TinyMcePhoto.new({"uploaded_data" => params[:media][:photo]})
    @photo.user = @me
    
    if @photo.save
      GC.start
      responds_to_parent do
        render :update do |page|
          page << "upload_image_callback('#{@photo.public_filename()}', '#{@photo.display_name}', '#{@photo.id}');"
        end
      end
    else
      responds_to_parent do
        render :update do |page|
          page.alert('Sorry, there was an error uploading the photo.')
        end
      end
    end
  end

  def curblyadvimage
    render :layout => false
  end
end
