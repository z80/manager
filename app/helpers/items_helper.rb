module ItemsHelper

    def users
        @users = User.all
        a = []
        @users.each do |u|
           s = u.name + ' ' + u.surname
           a.append( [ s, u.id ] )
        end
        @users = a
    end

    def statuses
      s = ItemStatus.all
      t = []
      s.each do |is|
        t.append( [ is.name, is.id ] )
      end
      return t
    end

end
