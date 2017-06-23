require "mini_magick"
require "dejisute_s3.rb"

module MagickThumbs
  include MiniMagick

  #MC -- TODO get proper processor
  #MiniMagick.processor = :gm

  def self.make_thumbs(options = {})
    url = options[:file_url]
    name = options[:file_name]
    #put a default size here
    size = options[:size] || name.scan(/\_(\d{1,3}x\d{1,3})/).flatten.first
    image = MiniMagick::Image.open(url)
    image.resize size
    out_name = File.join("public/data/preview",name)
    image.write(out_name)
    
    if !options[:remote_upload].nil?
      DejisuteS3.upload(:file_path => out_name, :file_name => name)
      File.delete(out_name) if File.exists?(out_name)
    end
    return name    
  end
  
end
