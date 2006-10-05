class TagController < ApplicationController
  layout "basic", :only => :index

  def index
    @tags = Tag.find_by_sql("SELECT name, COUNT(name) AS count FROM tags GROUP BY name")
  end

  def add
    tag_name = @params[:tag][:name]
    image_id = @params[:tag][:image_id]
    user_name = @params[:tag][:user_name]
    unless Tag.find(:first,
                    :conditions => [
                      "name=? AND user_name=? AND image_id=?",
                      tag_name,
                      user_name,
                      image_id
                    ]) then
      tag = Tag.new
      tag.attributes = @params[:tag]
      tag.name.strip!
      tag.save
    end
    redirect_to "/image/#{Image.find(image_id).md5id}"
  end

  def destroy
    unless @session[:user_name] # provide crawller
      redirect_to "/"
      return
    end
    tag = Tag.find @params[:id] rescue nil
    unless tag
      redirect_to "/"
      return
    end
    image_id = tag.image_id # for redirect
    tag.destroy
    redirect_to "/image/#{Image.find(image_id).md5id}"
  end
end
