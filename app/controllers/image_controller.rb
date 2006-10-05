class ImageController < ApplicationController
  layout 'basic'

  def index
  end

  def show
    @image = Image.find_by_md5id(@params[:md5id])
    
    if @image==nil then
      if (@session[:user_name])
        redirect_to "/#{@session[:user_name]}/"
      else
        redirect_to "/"
      end
      return
    end
    @is_owner = @image.is_owned_by(@session[:user_name]);
    @tags = Tag.find_all_by_image_id(@image.id)
    @derivatives = Image.find_all_by_source(@image.id)
    @sources = @image.sources

    @history_names = @sources.collect do |source|
      source.user_name
    end
    @history_names.push @image.user_name
    @history_names.uniq!
  end

  def tree
    @image = Image.find_by_md5id(@params[:md5id])
    
    if @image==nil then
      if (@session[:user_name])
        redirect_to "/#{@session[:user_name]}/"
      else
        redirect_to "/"
      end
      return
    end
  end

  def list
    limit = 10
    @pages, @images = paginate(:images,
                               :per_page => limit,
                               :order_by => 'lastupdate DESC')
  end

  def user
    @user_name = @params[:user_name]
    @is_owner = (@session[:user_name] and
                 @user_name == @session[:user_name])
    @tags = Tag.find_by_sql("SELECT name, COUNT(name) AS count FROM tags WHERE user_name=\"#{@user_name}\" GROUP BY name")

    limit = 10
    if @params[:tag]
      @pages, @images = paginate(:images,
                                 :include => [:tags],
                                 :conditions => ["images.user_name = ? AND tags.name = ?",
                                   @user_name,
                                   @params[:tag]],
                                 :per_page => limit,
                                 :order_by => 'lastupdate DESC')
    else
      @pages, @images = paginate(:images,
                                :per_page => limit,
                                :conditions => ["user_name = ?", @user_name],
                                :order_by => 'lastupdate DESC')
    end
    
    t = @params[:tag] ? CGI.escape(@params[:tag]) : ''
    @page_url = "/#{@user_name}/#{t}"
    if @pages.current.previous
      @previous_page_url = "#{@page_url}?page=#{@pages.current.previous.number}"
    end
    if @pages.current.next
      @next_page_url = "#{@page_url}?page=#{@pages.current.next.number}"
    end
  end

  def tag
    @tag_name = @params[:name]
    @limit = 10
    @offset = (@params[:offset]) ? @params[:offset].to_i : 0
    @images = Image.find(:all,
                         :include => [:tags],
                         :conditions => ["tags.name = ?", @tag_name],
                         :limit => @limit,
                         :order => 'lastupdate DESC')
    @length = Image.find(:all,
                         :include => [:tags],
                         :conditions => ["tags.name = ?", @tag_name]).length
  end

  def new_item
    if (!@session[:user_name])
      render :text => 'error'
      return
    end

    @image = Image.new_item @session[:user_name]
    if (@params[:md5id])
      @image.md5id = @params[:md5id]
    end
    
    @flash_vars = "source_url=/new.xml&" +
                 "save_url=/image/save/#{@image.md5id}"
    render :action => 'edit'
  end

  def edit
    @image = Image.find_by_md5id(@params[:md5id])
    if (@image.user_name != @session[:user_name])
      redirect_to "/image/#{@params[:md5id]}"
      return
    end
    @flash_vars = "source_url=/data/#{@image.md5id}.xml&" +
                  "save_url=/image/save/#{@image.md5id}"
  end

  def save
    image = Image.find_by_md5id(@params[:md5id])
    if image==nil
      image = Image.new
      image.id = @params[:id]
      image.md5id = @params[:md5id]
      image.user_name = @session[:user_name]
      image.title = 'no title'
    else
      if (image.user_name != @session[:user_name])
        render_text "fail"
        return
      end
    end

    begin
      imgfile = ImageFile.new(image.md5id)
      imgfile.save @params["xml"]
      imgfile.save_svg @params["svg"]
      imgfile.svg2png
    rescue
      render_text "fail"
      return
    end
    image[:lastupdate] = Time.now
    if image.save
      render_text "ok"
    else
      render_text "fail"
    end
  end

  def destroy
    image = Image.find_by_md5id(@params[:md5id])
    if (image.user_name != @session[:user_name])
      redirect_to "/image/#{@params[:id]}"
      return
    end

    destinations = Image.find(:all,
                              :conditions=>["source=?", image.id])
    destinations.each do |dest|
      dest.update_attribute "source", nil
    end
    
    user_name = image.user_name # for redirect
    image.destroy
    ImageFile.new(image.md5id).delete
    redirect_to "/#{user_name}/"
  end

  def copy
    source = Image.find_by_md5id(@params[:md5id])
    unless @session[:user_name]
      redirect_to "/image/#{source.md5id}"
      return
    end
    
    newTitle = (source.title && source.title!="") ? "copy of #{source.title}" : ''
    require 'digest/md5'
    md5id = Digest::MD5.hexdigest(@session[:user_name]+Time.now.to_i.to_s)
    destination = Image.new(:md5id => md5id,
                            :title => newTitle,
                            :user_name => @session[:user_name],
                            :lastupdate => Time.now,
                            :source => source.id)
    #destination.id = md5id
    destination.save
    ImageFile.new(source.md5id).copy_to(destination.md5id)
    redirect_to "/image/#{destination.md5id}"
  end

  def set_image_title # Ajax
    image = Image.find_by_md5id(@params[:md5id])
    if (image.user_name != @session[:user_name])
      render_text ""
      return
    end
    old_title = image.title
    new_title = @params[:value].strip
    if (new_title==nil)
      new_title = ""
    end
    image.title = new_title
    if image.save
      render_text new_title
    else
      render_text 'save miss'
#      render_text old_title
    end
  end
end
