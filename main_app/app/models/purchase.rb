class Purchase < ActiveRecord::Base
  #email is temp until we introduce an autogenerated user for purchases
  attr_accessible :link_id, :state, :user_id, :email, :link_name, :link_price
  DEFAULT_CURRENCY = "usd"
  
  #associations
  belongs_to :link
  belongs_to :user
  has_one :purchase_transaction

  after_create do 
    generate_unique_download_key
  end

  def increase_views_count!
    view_count = self.views.to_i + 1
    self.update_attribute(:views, view_count)
  end


  def perform_purchase!(options = {})
    amount = options[:amount] || self.link.price
    currency = options[:currency] || DEFAULT_CURRENCY
    description = options[:description] || "LINK #{self.link.id} PURCHASE" 
    charge = Stripe::Charge.create(
                                   :amount => (self.link.price * 100).round,
                                   :currency => currency,
                                   :card => self.token,
                                   :description => description
                                   )
    
    self.update_attributes(:link_name => self.link.name, :link_price => self.link.price)

    self.create_purchase_transaction!(:link_id => self.link_id, :response_data => charge.as_json)
  end


  #MC -- Maybe move this to Link.rb, as nothing in it is purchase specific, until we add some protection
  def purchase_download_link
    File.join(AWS_URL, AWS_BUCKET, AWS_UPLOAD_DIR, self.link.unique_url)
  end

  private 
  #generates a random 32 length key
  def generate_unique_download_key
    k1,k2 = Digest::MD5.hexdigest(self.id.to_s)[0..10], Digest::MD5.hexdigest(self.id.to_s)[27..32]
    self.update_attribute(:unique_download_key, SecureRandom.hex(8) + k1 + k2)
  end

end
