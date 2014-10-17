
require 'mail'

module OrdersHelper

  options = { :address              => "smtp.gmail.com",
              :port                 => 587,
              :domain               => 'ipm-3d-print',
              :user_name            => 'aist.nt.redmine@gmail.com',
              :password             => '314159265352718281828aist-nt',
              :authentication       => 'plain',
              :enable_starttls_auto => true  }



  Mail.defaults do
    delivery_method :smtp, options
  end  

  def sendEmail( recipient, subj, content )
    sender = User.find_by_admin( true ).first
    Mail.deliver do
      to      recipient
      from    sender
      subject subj
      body    bdy
    end
  end

  def inform_new_order( order )
    u = User.find_by_id( order.user_id )
    title = "New order by " + u.email
    body = "The user with email " + u.email + " has placed a new " + link_to( "order", order )

    adms = User.find_by_admin( true )
    adms.each do |a|
      sendEmail( a.email, title, body )
    end
  end

  def inform_order_status_change( order )
    u = User.firn_by_id( order.user_id )
    title = "Your order status\'s changed"
    body = "order number " + order.id + "\r\n" + 
           "order new status " + order.status

    sendEmail( u.email, title, body )
  end

end





