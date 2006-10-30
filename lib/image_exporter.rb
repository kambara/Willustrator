require 'rubygems'
require_gem 'gd2'


class ImageExporter
  class ImageExporterException < StandardError
  end

  def self.export(filepath, width, height, data)
    raw = uncompress(data)

    ## verify
    if (width * height != raw.size)
      raise ImageExporterException, 'invalid size'
      return
    end

    image = GD2::Image::TrueColor.new(width, height)
    height.times do |y|
      width.times do |x|
        i = y * width + x
        color = raw[i]
        image.set_pixel(x, y, color.to_i)
      end
    end

    image.export filepath
  end

  def self.uncompress(data)
    ary = data.split(',')
    raw = []

    i = 0
    while i < ary.size
      c = ary[i].to_i(32)
      color = int2color c
      count_str = ary[i+1]
      count = (count_str == '') ? 1 : count_str.to_i
      count.times do |n|
        raw.push color
      end
      i += 2
    end

    return raw
  end

  def self.int2color(i)
    r = (i & 0xFF0000) >> 16
    g = (i & 0xFF00) >> 8
    b = i & 0xFF
    return GD2::Color[r.to_f/255, g.to_f/255, b.to_f/255]
  end
end
