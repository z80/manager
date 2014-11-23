class ItemsController < ApplicationController
  # Authentication routines
  include UsersHelper
  include PartsHelper
  include ItemsHelper
  include ContractsHelper

  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @user  = current_user
    if ( params[ :search ] ) then
      @paginate = false
      @items = search( Item, params[ :search ], [ 'supplier_id', 'internal_id', 'desc', 'order_link', 'contract_id', 'deliver_addr', 'comment' ] )
    else
      @paginate = true
      if ( params[ :status_id ] && (params[ :status_id ].to_i > 0) )
        @items = Item.where( status_id: params[ :status_id ] )
      else
        @items = Item.all
      end
      if ( params[ :user_resp_id ] && (params[ :user_resp_id ].to_i > 0) )
        @items = @items.where( user_resp_id: params[ :user_resp_id ] )
      end
      if ( params[ :user_placed_id ] && (params[ :user_placed_id ].to_i > 0) )
        @items = @items.where( user_placed_id: params[ :user_placed_id ] )
      end
      if ( params[ :contract_id ] && (params[ :contract_id ].to_i > 0) )
        @items = @items.where( contract_id: params[ :contract_id ] )
      end
      if ( params[ :only_valid_today ] )
        @items = @items.where( "order_date <= ?", Date.today )
      end
      @items = @items.page( params[:page] )
    end
    @users = users
    @users.prepend( [ "None", -1 ] )
    @user_placed_id = params[ :user_placed_id ]
    @user_resp_id = params[ :user_resp_id ]

    @statuses = statuses
    @statuses.prepend( [ "None", -1 ] )
    @status_id = params[ :status_id ]

    @contracts = active_contracts
    @contracts.prepend( [ "None", -1 ] )
    @contract_id = params[ :contract_id ]

    @only_valid_today = ( params[ :only_valid_today ] ) ? "true" : "false"
  end

  def my
    @user = current_user
    #puts '##################################################'
    #puts @items.class
    #puts @items.respond_to?( :each )
    #puts @items.size


    if ( params[ :search ] ) then
        @paginate = false
        ii = search( Item, params[ :search ], [ 'supplier_id', 'internal_id', 'desc', 'order_link', 'contract_id', 'deliver_addr', 'comment' ] )
        @items = []
        ii.each do |item|
            if ( item.user_resp_id == @user.id ) then
                @items.append( item )
            end
        end
    else
        @paginate = true
        @items = Item.where( user_resp_id: @user.id )
        @paginate = @items.respond_to?( :each )
        @items = @items.paginate( page: params[:page], per_page: 10 )
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @user = current_user
  end

  # GET /items/new
  def new
    @user = current_user
    @item  = Item.new

    @users = users

    @statuses = statuses

    @contracts = active_contracts()
    @contracts.prepend( [ "None", -1 ] )
  end

  # GET /items/1/edit
  def edit
    @users = users

    @statuses = statuses

    @contracts = active_contracts()
    
    @contracts.prepend( [ "None", -1 ] )
    @contract_id = @item.contract_id || -1
  end

  def copy
    @user  = current_user
    if @user then
        user = @user.name + ' ' + @user.surname
    end
    @users = users
    @item  = Item.find( params[ :id ] )
    @statuses = statuses
    @contracts = active_contracts
    @contracts.prepend( [ "None", -1 ] )
    @contract_id = @item.contract_id
  end

  def copy_submit
    #puts '============================================'
    #puts '############################################'

    @user = current_user
    @item = Item.new( params )
    @item.user_placed = @user.id
    srcItem = Item.find( params[ :orig_id ] )

    #debugger

    if ( params[ :image ] )
        @item.image = params[ :image ]
    else
        @item.image = srcItem.image
    end
    if @item.save
        redirect_to @item, notice: 'Item was successfully copied.'
    else
        @user  = current_user
        if @user then
            user = @user.name + ' ' + @user.surname
        end
        @users = users
        render action: 'copy', notice: 'Failed to creace item!'
    end
  end

  # POST /items
  # POST /items.json
  def create
    @user   = current_user
    #item_params.user_placed = @user.id
    @item = Item.new(item_params)
    @item.user_placed = @user.id
    if ( params[ :item ][ :image ] ) then
        @item.image = params[ :item ][ :image ]
    end
    #debugger

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    if ( params[ :item ][ :image ] ) then
        @item.image = params[ :item ][ :image ]
    end
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  #def destroy
  #  @user = current_user
  #  if ( @user && @user.admin? ) then
  #      @item.destroy
  #      respond_to do |format|
  #          format.html { redirect_to items_url }
  #          format.json { head :no_content }
  #      end
  #  else
  #      redirect_to root_path
  #  end
  #end

  # GET /items/1
  def convert_form
    @item = Item.find_by_id( params[ :id ] )
    @user  = current_user
    if ( params[ :search ] ) then
        @parts = search( Part, params[:search], [ 'own_id', 'third_id', 'desc' ] )
        @paginate_parts = false
    else
        @parts = Part.paginate( page: params[ :part_page ], per_page: 10 )
        @paginate_parts = true
    end
    @boxes = Box.paginate( page: params[ :box_page ], per_page: 10 )
    @paginate_boxes = true
  end

  # POST /items/1
  def convert
    @user = current_user
    @item = Item.find_by_id( params[ :id ] )
    @item.status = 'converted'
    inst = PartInst.new
    inst.user_id = @user.id
    inst.part_id = params[ :part_id ]
    inst.cnt     = params[ :cnt ]
    inst.box_id  = params[ :box_id ]
    if ( @item.save && inst.save ) then
        redirect_to items_path
    else
        redirect_to convert_form_path, notice: 'Failed to convert purchased item to parts!'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:supplier_id, 
                                   :internal_id, 
                                   :desc, 
                                   :order_link, 
                                   :contract_desc, 
                                   :deliver_addr, 
                                   :status, 
                                   :user_placed_id, 
                                   :user_resp_id, 
                                   :set_sz, 
                                   :sets_cnt, 
                                   :unit_price, 
                                   :comment, 
                                   :image, 
                                   :status_id, 
                                   :order_date, 
                                   :contract_id, 
                                   :only_valid_today )
    end

end
