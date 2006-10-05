require 'rexml/document'
require 'jcode'
require 'pathname'
require 'rsvg2'
$KCODE="UTF8"

class ImageFile
  def initialize(id)
    @image_id = id.to_s
    @xml_path = create_xml_path(id)
    @svg_path = create_svg_path(id)
    @png_path = create_png_path(id)
    @small_path = create_small_path(id)
  end

  def create_xml_path(id)
    Pathname.new "public/data/#{id}.xml"
  end
  def create_svg_path(id)
    Pathname.new "public/data/#{id}.svg"
  end
  def create_png_path(id)
    Pathname.new "public/data/#{id}.png"
  end
  def create_small_path(id)
    Pathname.new "public/data/#{id}_small.png"
  end

  def save(str)
    @xml_path.open('w') { |f|
      f.write(str)
    }
  end

  def save_svg(str)
    @svg_path.open('w') { |f|
      f.write(str)
    }
  end

  def svg2png
    pixbuf = RSVG.pixbuf_from_file(@svg_path.to_s)
    pixbuf.save(@png_path.to_s, 'png') unless pixbuf.nil?
    pixbuf_small = RSVG.pixbuf_from_file_at_max_size(@svg_path.to_s, 100, 100)
    pixbuf_small.save(@small_path.to_s, 'png') unless pixbuf_small.nil?
  end

  def delete
    @xml_path.delete if @xml_path.exist?
    @svg_path.delete if @svg_path.exist?
    @png_path.delete if @png_path.exist?
    @small_path.delete if @small_path.exist?
  end

  def copy_to(id)
    FileUtils.cp(@xml_path.to_s, create_xml_path(id)) if @xml_path.exist?
    FileUtils.cp(@svg_path.to_s, create_svg_path(id)) if @svg_path.exist?
    FileUtils.cp(@png_path.to_s, create_png_path(id)) if @png_path.exist?
    FileUtils.cp(@small_path.to_s, create_small_path(id)) if @small_path.exist?
  end
end
