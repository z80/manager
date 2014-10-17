# == Schema Information
#
# Table name: logs
#
#  id         :integer          not null, primary key
#  msg        :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Log < ActiveRecord::Base
  def user
  	if ( User.exists?( self.user_id ) )
      u = User.find( self.user_id )
      return u.name_stri
    end
    return "Unspecified"
  end

  def log_stri( link_to=nil )
    stri = self.msg
    return stri
  end
end


