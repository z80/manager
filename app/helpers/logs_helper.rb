module LogsHelper
  def log( msg, user=nil )
    l = Log.new
    l.msg = msg.to_s
    if ( user )
    	l.user_id = user.id
    end
    l.save
  end
end
