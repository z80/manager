class StaticPagesController < ApplicationController
  include UsersHelper
  include LogsHelper

  def index
    #@images = Image.all
    #@user   = current_user
    #@items = Item.paginate( page: params[:page], per_page: 10, order: "id DESC" )
    #@static_pages = @items
    redirect_to contracts_path
  end

  def submit
    flash[:submit] = params[ :my_text ]
    #puts ">>>>>>>>>>>>>>>>>>>>>>>>>"
    #10.times do
    #    puts params[:submit]
    #    puts params["submit"]
    #    puts params["my_text"]
    #    puts params[:my_text]
    #end
    #puts "<<<<<<<<<<<<<<<<<<<<<<<<<"
    redirect_to static_pages_index_path
  end


  def submitImage
    #debugger;
    image = Image.new()
    image.avatar = params[ :avatar ]
    if ( image.save! )
        flash[ :success ] = "Image saved!"
    else
        flash[ :error ] = "Image upload failed!"
    end
    redirect_to static_pages_index_path
  end

  def new_user_form
    @user = current_user
    #debugger
  end
  
  def user_sign_in
    email    = params[ :email ]
    password = params[ :password ]
    #debugger
    user = User.find_by_email( email )
    if ( user && user.authenticate( password ) )
      sign_in user
      log( "User signed in", user )

      redirect_to root_path
    else
      flash.now[ :error ] = 'Invalid email or password combination'
      render static_pages_user_sign_in_form_path
    end
  end

  def user_sign_out
    sign_out
    redirect_to root_path
  end

  def user_register
    #if simple_captcha_valid?
    u = User.new
    u.email                 = params[ :email ]
    u.name                  = params[ :name ]
    u.surname               = params[ :surname ]
    u.password              = params[ :password ]
    u.password_confirmation = params[ :password_confirmation ]
    u.avatar                = params[ :avatar ]
    u.admin                 = ( current_user && current_user.admin? ) ? (params[ :admin ] || false) : false
  
    #debugger
    current_user = u
    @user        = u
    #end
    if ( u && u.save )
      sign_in     u
      flash[ :success ] = "Created new user!"
      log( "New user registered", @user )
      
      redirect_to root_path
    else
      flash[ :error ] = "New user creation failed!"

      redirect_to static_pages_new_user_form_path, notice: 'Error creating new user!'
    end
  end


private

  # Use strong_parameters for attribute whitelisting
  # Be sure to update your create() and update() controller methods.

  def user_params
    params.require( :image ).permit( :avatar )
  end

end




