class Profile < ActiveRecord::Base
  attr_accessible :bio, :fullname, :settings, :user_id, :username

  #validates_presence_of :username, :on => :update
  #validates_presence_of :bio, :on => :update
  #validates_presence_of :fullname, :on => :update
  
  
  belongs_to :user
  
end
