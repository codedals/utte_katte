class Link < ActiveRecord::Base

  MINIMUM_PRICE = 1.0

  #Limit for checking collision space of SecureRandom strings before increasing length
  ITERATION_LIMIT = 100
  
  attr_accessor :upload_tmp
  attr_accessible :name, :price, :upload_path, :url, :upload_tmp, :description, :active

  serialize :file_description, JSON

  validates_presence_of :name, :message => "Name can't be blank."
  validates_presence_of :upload_tmp, :on => :create, :message => "Links need an associated file to be valid."  
  #NEED TO CHECK CURRENCY STUFF
  validates_numericality_of :price, :greater_than_or_equal_to => MINIMUM_PRICE, :message => "Price must be greater than or equal to $#{MINIMUM_PRICE}."
  #validate :has_associated_file

  #associations
  belongs_to :user
  has_many :purchases
  belongs_to :store
  has_many :purchases
  has_many :purchase_transactions

  def to_param
    self.identity_key
  end


  def get_ext_type
    ext_name = get_ext_name
    case 
    when [:avi, :mp4].include?(ext_name)
      :video
    when [:mp3].include?(ext_name)
      :audio
    when [:jpg, :jpeg, :png, :gif].include?(ext_name)
      :image
    when [:txt,:doc, :docx,:pdf].include?(ext_name)
      :text
    else
      :unknown
    end
  end

  
  FULL_DIR = "public/data"
  PREVIEW_DIR = "public/data/preview"

  OTHER_FILE_EXT = 12

  FILE_EXT = { 
    :jpg => 1,
    :jpeg => 2,
    :png => 3,
    :avi => 4,
    :mp4 => 5,
    :txt => 6,
    :doc => 7,
    :docx => 8,
    :pdf => 9,
    :gif => 10,
    :mp3 => 11,
    :unknown => OTHER_FILE_EXT
  }

  def get_ext_name
    FILE_EXT.each do |k,v| 
      if FILE_EXT[k] == file_ext
        return k
      end
    end
  end

  scope :active, lambda{where("active = ?", true)}

  #hooks

  after_create do 
    generate_unique_identifier
    #handle_file_description
    #handle_preview_image
  end

  def increase_views_count!
    view_count = self.views.to_i + 1
    self.update_attribute(:views, view_count)
  end

  def purchase_count
    purchases.count
  end

  def save_upload(options = {})
    upload = options[:upload_tmp]
    if upload.nil?
      #MC -- TODO handle nil upload
      raise "NIL UPLOAD"
    end

    #MC -- Yes, I know this is silly
    upload_name = File.basename(upload.original_filename, '.*')
    upload_ext = File.extname(upload.original_filename)

    path = File.join(FULL_DIR,upload_name + upload_ext)
    new_name = SecureRandom.hex(8) + "_" + upload_name + upload_ext
    
    File.open(path, "wb") { |f| f.write(upload.read) }

    if self.file_description.nil? || self.file_description.try(:empty?)
      self.update_attribute(:file_description, {}) 
    end
    self.file_description[:size] = File.open(path).size

    File.rename(path, "#{FULL_DIR}/#{new_name}")
    
    DejiSuteS3.upload(:file_path => "public/data/#{new_name}", :file_name => new_name)
    self.update_attribute(:unique_url, new_name)

    self.update_attribute(:upload_path, new_name)
    fxt = FILE_EXT[upload_ext.try(:delete,"\.").try(:to_sym)] || OTHER_FILE_EXT

    self.update_attribute(:file_ext, fxt)

    #THIS IS BLOCKING!!!!
    handle_file_description
    #RAILS_DEFAULT_LOGGER.debug path.inspect    
  end

  def display_link
    APP_DOMAIN + "/" + identity_key
  end
  
  def raw_file(type=nil)
    if type == :preview
      PREVIEW_DIR + "\/" + upload_path
    else
      FULL_DIR + "\/" + upload_path
    end
  end

  #ASSET PATH IS IS NOT WORKING
  def preview_image
    PREVIEW_DIR + "\/" + preview_file_path.to_s
  end

  def display_file_size(options = {})
    measure = options[:measure] || :kb
    case measure 
    when :kb
      (file_description["size"].to_f / 1000).round
    else
      file_description["size"]
    end
  end
  
  def resolution
    return nil unless get_ext_type == :image
    {:width => file_description["resolution"][0],
      :height => file_description["resolution"][1]
    }
  end

  private 

  def handle_file_description    
    type = self.get_ext_type

    case type
    when :image
      image = MagickThumbs::Image.open(self.raw_file)
      self.file_description[:resolution] = [image[:width],image[:height]]
      make_preview_image(self.raw_file, type)
    when :text
      if self.get_ext_name == :pdf
        make_preview_image(self.raw_file, type)
      end
    else
      nil 
    end
    self.save
  end
  
  #MAKE A PREVIEW DIRECTORY AND FULL DIRECTORY
  def make_preview_image(file,type)
    case type
    when :text
      Docsplit.extract_images(file, :size => '400x', :format => [:png], :pages => 1, :output => PREVIEW_DIR)
      #the _1 is a peculiarity of Docsplit when selecting individual pages
      name = File.basename(upload_path, '.*') + "_1" +".png"
      self.update_attribute(:preview_file_path, name)
    when  :image
      name = MagickThumbs.make_thumbs(:file_url => file, :file_name => self.upload_path, :size => "200x200")
      self.update_attribute(:preview_file_path, name)
    else
      nil 
    end
  end


  def generate_unique_identifier
    #Check collision probability space
    #the length of the string should be set in db
    iterations = 0 
    temp_identifier = SecureRandom.urlsafe_base64(3)
    while Link.find_by_identity_key(temp_identifier)
      if iterations > ITERATION_LIMIT
        #handle_collisions by increaing rand string length
        return nil
      end
      temp_identifier = SecureRandom.urlsafe_base64(3)
      iterations += 1
    end
    self.update_attribute(:identity_key, temp_identifier)
  end

end
