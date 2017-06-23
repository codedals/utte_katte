class User < ActiveRecord::Base

  has_secure_password

  before_validation :linked_account_check

  attr_accessible :email, :password, :password_confirmation, :has_linked_account

  validates_presence_of :email, :message => "Email can't be blank.", :if => Proc.new { |user| user.has_linked_account != true }
  validates_uniqueness_of :email, :case_sensitive => false, :message => "Email already taken."
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, :message => "Email is invalid."}, :if => Proc.new { |user| user.has_linked_account != true } 

  validates_presence_of :password, :on => :create, :message => "Password can't be blank.", :if => Proc.new { |user| user.has_linked_account != true }
  validates_length_of :password, :minimum => 5, :too_short => "Password must be at least %{count} characters.", :if => Proc.new { |user| user.has_linked_account != true }

  after_create do
    generate_verfication_key
    generate_blank_profile
  end

  ROLE = {
    :admin  => 0,
    :superuser => 1,
  }


  #associations
  has_many :links
  has_one :profile
  has_many :purchases
  has_many :linked_accounts
  
  LinkedAccount::PROVIDERS.each do |k,v|
    act = (k.to_s + "_account").to_sym
    has_one act
  end

  def display_balance
    balance.to_f
  end

  def total_sales
    nil
  end

  def verify!
    self.update_attribute(:verified_email, true)
    self.update_attribute(:verification_key, nil)
  end

  private

  def linked_account_check
    if self.has_linked_account
      self.update_attribute(:password_digest, 0)
    end
  end
  
  def generate_blank_profile
    self.create_profile
  end

  def generate_verfication_key
    key = SecureRandom.hex(16) + self.id.to_s
    key = Digest::MD5.hexdigest(key)
    self.update_attribute(:verification_key, key)
  end
  
end
