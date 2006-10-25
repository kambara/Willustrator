class JsonController < ApplicationController
  def user_old
    images = Image.find(:all,
                        :conditions => ["user_name = ?", @params[:user_name]],
                        :order => 'lastupdate DESC')
    images_ary = []
    site_url = "http://#{@request.env['HTTP_HOST']}"
    images.each do |image|
      images_ary.push({
                        :title => image.title || '',
                        :link  => "#{site_url}/image/#{image.md5id.to_s}",
                        :png   => "#{site_url}/data/#{image.md5id.to_s}.png",
                        :small => "#{site_url}/data/#{image.md5id.to_s}_small.png",
                        :svg   => "#{site_url}/data/#{image.md5id.to_s}.svg",
                      })
    end
    render :text => {:images => images_ary}.to_json
  end

  def user
    images = Image.find(:all,
                        :conditions => ["user_name = ?", @params[:user_name]],
                        :order => 'lastupdate DESC')
    images_ary = []
    site_url = "http://#{@request.env['HTTP_HOST']}"
    images.each do |image|
      images_ary.push({
                        :title => image.title || '',
                        :link  => "#{site_url}/image/#{image.md5id.to_s}",
                        :png   => "#{site_url}/data/#{image.md5id.to_s}.png",
                        :small => "#{site_url}/data/#{image.md5id.to_s}_small.png",
                        :svg   => "#{site_url}/data/#{image.md5id.to_s}.svg",
                      })
    end
    json = images_ary.to_json
    if (@params['jsonp'])
      render :text => "#{@params['jsonp']}(#{json});"
    else
      render :text => json
    end
  end

  def new_image
    json = ''
    if (!@session[:user_name])
      json = {:error => 'need to login'}.to_json
    else
      site_url = "http://#{@request.env['HTTP_HOST']}"
      image = Image.new_item @session[:user_name]
      json = {
        :owner => @session[:user_name],
        :link  => "#{site_url}/image/#{image.md5id.to_s}",
        :edit  => "#{site_url}/image/new_item/#{image.md5id.to_s}",
        :png   => "#{site_url}/data/#{image.md5id.to_s}.png",
        :small => "#{site_url}/data/#{image.md5id.to_s}_small.png",
        :svg   => "#{site_url}/data/#{image.md5id.to_s}.svg",
      }.to_json
    end
    if (@params['jsonp'])
      render :text => "#{@params['jsonp']}(#{json});"
    else
      render :text => json
    end
  end

  def tag
  end
end
