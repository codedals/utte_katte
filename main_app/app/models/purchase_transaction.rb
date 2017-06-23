class PurchaseTransaction < ActiveRecord::Base
  attr_accessible :purchase_id, :response_data, :link_id
  serialize :response_data, JSON
  
  #associations
  belongs_to :purchase
  belongs_to :link
  
  after_create do 
    return nil if response_data.nil?
    if (update_user_balance)
      deliver_link
    end
  end

  private
  #returns a boolean
  def update_user_balance
    if self.response_data["failure_message"].nil? and self.response_data["paid"] == true
      #MC -- TODO -- Handle DejiSutes balance/profit
      #MC -- TODO -- this is pretty deep nesting...
      user_balance = self.link.user.balance.to_i
      #MC -- TODO -- amount and fee should be constants somewhere
      #MC -- TODO -- the divide by 100 is OF CRUCIAL IMPORTANCE!!!!!!! Maybe we should just use cents for everything?
      update_amount = ((self.response_data["amount"] - self.response_data["fee"]) / 100).to_f.round
      self.link.user.update_attribute(:balance, user_balance + update_amount)
      self.link.user.save

      link_total_sales = self.link.total_sales.to_i
      self.link.update_attribute(:total_sales, link_total_sales + update_amount)
      self.link.save
    end
  end

  def deliver_link
    UserMailer.item_sold(self.link.user, self.purchase).deliver
  end

end
