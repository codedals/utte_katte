class Store < ActiveRecord::Base
  attr_accessible :name, :user_id, :visits

  belongs_to :user 
  has_many :links

end
