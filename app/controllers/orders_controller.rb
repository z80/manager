class OrdersController < ApplicationController

  include UsersHelper
  #include OrdersHelper

  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    u = current_user
    @user = u
    if ( u and u.admin? )
      @orders = Order.all
    else
      @orders = nil
      redirect_to static_pages_index_path, notice: 'You are not authorized to view orders list.'
    end

  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @user = current_user
  end

  # GET /orders/new
  def new
  end

  def my_orders
    @user = current_user
    if ( @user )
      @orders = @user.orders
    else
      @orders = nil
    end
  end

  # GET /orders/1/edit
  def edit
    @user = current_user
    u = @user
    if ( u.admin? )
      o = u.orders.find_by_id( params[ :id ] )
      $order = o
    else
      redirect_to static_pages_index_path, notice: "You are not authorize to make changes into orders."
    end
  end

  # POST /orders
  # POST /orders.json
  def create
    #@order = Order.new(order_params)
    u = current_user
    @user = u
    if ( u )
      @order = u.orders.new
      o = @order
      o.desc = params[ :desc ]
      o.attachment = params[ :file ]
      if ( o.save )
        redirect_to o, notice: 'Order was successfully placed'
      else
        render new_order_path
      end
    end

    #format.html { redirect_to @order, notice: 'Order was successfully created.' }
    #format.html { render action: 'new' }
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    #debugger
    u = current_user
    @user = u
    if ( u.admin? )
      o = u.orders.find_by_id( params[ :id ][ :id ] )
      o.status = params[ :status ]
      if ( o.save )
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:user_id, :desc, :status)
    end
end




