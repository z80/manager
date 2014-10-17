module UsersHelper

  def sign_in( user )
    cookies.permanent[ :remember_token ] = user.remember_token
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete( :remember_token )
  end

  def current_user=( user )
    @current_user = user
  end

  def current_user
    token = cookies[ :remember_token ]
    user = User.find_by_remember_token( token )
    @current_user ||= user
  end

end
