class Image < ActiveRecord::Base
  has_many :tags, :dependent => true

  validates_length_of(:title,
                      :maximum=>100,
                      :message=>'too long')
  # <>&/\'",.;
  validates_format_of(:title,
                      :with => /^[^<>&\/\\'",\.;]*$/,  #"'
                      :message=>'bad char')

  def self.find_by_md5id(md5id)
    self.find(:first,
              :conditions => ["md5id=?", md5id])
  end

  def self.find_all_by_source(source_id)
    self.find(:all,
              :conditions => ["source=?", source_id])
  end

  def is_owned_by(user_name)
    return (self.user_name == user_name)
  end

  def sources
    if source and Image.exists?(source) then
      source_image = Image.find(source)
      return source_image.sources.push(source_image)
    else
      return []
    end
  end
  # original(root)がfirst. last editが最後

  def derivatives
    Image.find_all_by_source(self.id)
  end

  def src_png
    png = "/data/#{self.md5id}.png"
    return (File.exist?("public" + png)) ? png : "/images/no_image.png"
  end

  def src_small
    png = "/data/#{self.md5id}_small.png"
    return (File.exist?("public" + png)) ? png : "/images/no_image.png"
  end

  def self.new_item(user_name)
    require 'digest/md5'
    new_md5id = Digest::MD5.hexdigest(user_name + Time.now.to_i.to_s)
    return Image.new(:md5id => new_md5id,
                     :title => 'no title')
  end

  def export_xml(str)
    open("public/data/#{self.md5id}.xml", "w") do |f|
      f.write(str)
    end
  end

  def export_png(w, h, data)
    png_path = "public/data/#{self.md5id}.png"
    small_path = "public/data/#{self.md5id}_small.png"

    #ImageExporter::export(png_path, w, h, data)
    img = ImageExporter.new(w, h, data)
    img.export(png_path)
    img.thumbnail(small_path, 100, 100)
  end
end
