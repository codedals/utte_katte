class UserMailer < ActionMailer::Base
  default from: "no-reply@dejisute.com"

  def verification_email(user)
    @user = user
    # @url = some_verfication_path, :verification_key => some_key
    mail(:to => user.email, :subject => "Welcome to Dejisute!")
  end

  #sent to link creator
  def item_sold(user,purchase)
    @user = user
    @purchase = purchase

    mail(:to => user.email, :subject => "You sold something on Dejisute!")
  end
  
  #sent to link purchaser
  def item_purchased(user,purchase)
    @user = user
    @purchase = purchase

    mail(:to => user.email, :subject => "You bought something on Dejisute!")
  end

  def purchase_email(email, purchase)  
    @email = email
    @purchase = purchase

    mail(:to => email, :subject => "You bought #{purchase.link.name}! on Dejisute!")
  end

end
