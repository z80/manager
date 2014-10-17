class UsersController < ApplicationController

  include UsersHelper

  #before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def all
    #if ( current_user && current_user.admin? )
    #  @users = User.all
    #else
    #  @users = nil
    #end
      puts '#########################################'
      puts 'here!'
      puts @user
      puts '+++++++++++++++++++++++++++++++++++++++++'

    @users = User.all
  end

  def index
    all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find_by_id( params[ :id ] )
  end


  # GET /users/1/edit
  def edit
    @user = User.find_by_id( params[ :id ] )
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    set_user
    p = user_params
    @user.name    = p[ :name ]
    @user.surname = p[ :surname ]
    @user.email   = p[ :email ]
    @user.password = p[ :password ]
    @user.password_confirmation = p[ :password_confirmation ]
    @user.avatar   = p[ :avatar ]
    @user.admin = p[ :admin ]
    if @user.save
      redirect_to root_path, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    cu = current_user
    set_user
    if ( cu.admin )
      @user.destroy
    end
    redirect_to users_all_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :surname, :password, :password_confirmation, :avatar )
    end
end
