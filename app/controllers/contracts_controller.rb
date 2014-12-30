class ContractsController < ApplicationController
  include UsersHelper
  include PartsHelper
  include ItemsHelper
  include ContractsHelper
  include LogsHelper
  include ItemsHelper  

  before_action :set_contract, only: [:show, :edit, :update, :destroy]

  # GET /contracts
  # GET /contracts.json
  def index
    @user = current_user
    all = ( params[ :all ] || "false" ).to_bool
    if ( params[ :search ] ) then
      @paginate = false
      conts = search( Contract, params[ :search ], [ 'name', 'desc', 'ship_date' ] )
      if ( all )
        @contracts = conts
      else
        @contracts = []
        conts.each do |cont|
          @contracts.append( cont ) if (not cont.shipped)
        end
      end
    else
      @paginate = true
      if ( all )
        @contracts = Contract.all
      else
        @contracts = Contract.where( shipped: false )
      end
      sort_by = params[ :sort_by ]
      if ( sort_by == "number" )
        @contracts = @contracts.order( "number DESC" )
      elsif ( sort_by == "date" )
        @contracts = @contracts.order( "ship_date DESC" )
      else
        @contracts = @contracts.order( "ship_date DESC" )
      end
      @contracts = @contracts.page( params[:page] )
    end

    #@contracts = Contract.all
  end

  # GET /contracts/1
  # GET /contracts/1.json
  def show
    @user = current_user
    @contract = Contract.find( params[ :id ] )
    @ship_dates = @contract.ship_dates
    @ship_dates.prepend( [ "Any", -1 ] )
    @ship_date_id = params[ :date ] || -1

    @contract_items = items_by_date( @contract, params[ :sort_by ], params[ :date ] )

    @could, @couldnt, @parts_to_purchase, @days_to_assemble = @contract.contract_report()
    @level = @contract.warning_level( @could, @couldnt, @parts_to_purchase, @days_to_assemble )
    if ( @contract.warning != @level )
      @contract.warning = @level
      @contract.save
    end

    @owner = User.exists?( @contract.owner_id ) ? User.find( @contract.owner_id ) : nil
  end

  def adjust()
    @user = current_user
    @contract = Contract.find( params[ :id ] )
    # Taking actions from forms
    if ( params[ :add_prod_type_id ] )
      prod_type_id = params[ :add_prod_type_id ].to_i
      add_contract_item( @contract, prod_type_id )
      log( "Contract item is added for contract " + @contract.name, @user )
      
      redirect_to( edit_contract_path( @contract.id ) )
      return
    end

    if ( params[ :remove_item_id ] )
      id = params[ :remove_item_id ].to_i
      if ( ContractItem.exists?( id ) )
        remove_contract_item( id )
        log( "Contract item is removed for contract " + @contract.name, @user )
      
        redirect_to( edit_contract_path( @contract.id ) )
        return
      end
    end

    if ( params[ :contract_item_id ] && params[ :assign_product_id ] )
      item_id = params[ :contract_item_id ].to_i
      prod_id = params[ :assign_product_id ].to_i
      if ( ContractItem.exists?( item_id ) )
        ci = ContractItem.find( item_id )
        ci.product_id = prod_id
        ci.save

        p = ci.product
        p.box_id   = @contract.box_id
        p.owner_id = @contract.owner_id
        p.status   = ProductStatus.status_in_office()
        p.save

        log( "Contract item is assigned for contract " + @contract.name + ", product is " + ci.product.serial_number, @user )
      
        redirect_to( edit_contract_path( @contract.id ) )
        return
      end
    end
    redirect_to( edit_contract_path( @contract.id ) )
  end

  # GET /contracts/new
  def new
    @user = current_user
    @contract = Contract.new

    @users = users
    @users.prepend( [ "None", -1 ] )
    @owner_id = params[ :owner_id ] || -1
  end

  # GET /contracts/1/edit
  def edit
    @user = current_user
    @contract = Contract.find( params[ :id ] )
    @ship_dates = @contract.ship_dates
    @ship_dates.prepend( [ "Any", -1 ] )
    @ship_date_id = params[ :date ] || -1

    @contract_items = items_by_date( @contract, params[ :sort_by ], params[ :date ] )

    @users = users
    @users.prepend( [ "None", -1 ] )
    @owner_id = @contract.owner_id || -1
  end

  # POST /contracts
  # POST /contracts.json
  def create
    @user = current_user
    @contract = Contract.new(contract_params)

    respond_to do |format|
      if @contract.save
        log( "New contract is created: " + @contract.name, @user )
      
        format.html { redirect_to @contract, notice: 'Contract was successfully created.' }
        format.json { render action: 'show', status: :created, location: @contract }
      else
        format.html { render action: 'new' }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contracts/1
  # PATCH/PUT /contracts/1.json
  def update
    @user = current_user
    shipped = @contract.shipped
    respond_to do |format|
      if @contract.update(contract_params)
        log( "Contract " + @contract.name + " parameters are updated", @user )
        #if ( @contract.shipped && (not shipped) )
        #  mark_all_parts_shipped( @contract )
        #  log( "Contract " + @contract.name + " is marked as \'shipped\'", @user )
        #end
        format.html { redirect_to @contract, notice: 'Contract was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.json
  #def destroy
  #  @contract.destroy
  #  respond_to do |format|
  #    format.html { redirect_to contracts_url }
  #    format.json { head :no_content }
  #  end
  #end

  def add_item
    @user = current_user
    @contract   = Contract.find( params[ :id ] )
    #@prod_types = ProdType.all

    if ( params[ :search ] && (params[ :search ].size > 0) ) then
      @paginate   = false
      @prod_types = search( ProdType, params[ :search ], [ 'own_id', 'desc' ] )
    else
      @paginate   = true
      @prod_types = ProdType.paginate( page: params[:page], per_page: 10, order: "id DESC" )
    end
  end

  def assign_item
    @user = current_user
    @contract = Contract.find( params[ :id ] )
    item_id = params[ :item_id ].to_i
    @contract_item = ContractItem.find( item_id )
    @prod_type = @contract_item.prod_type

    @products, @paginate = @prod_type.products( true, params[ :search ], params[ :page ] )
  end

  def unassign_item()
    @user = current_user
    @contract = Contract.find( params[ :id ] )
    @contract_item = ContractItem.find( params[ :contract_item_id ] )
    p_id = @contract_item.product_id
    @contract_item.product_id = nil
    @contract_item.save

    p = Product.exists?( p_id ) ? Product.find( p_id ) : nil
    if ( p )
      p.status = ProductStatus.status_in_office
      p.save
    end

    redirect_to( edit_contract_path( @contract.id ), notice: 'Product was unassigned.' )
  end

  def parts_required
    @user = current_user
    event = params[:date]
    
    @date = Date.new( event["date(1i)"].to_i, event["date(2i)"].to_i, event["date(3i)"].to_i )
    if ( not @date )
      @date = 30.days.from_now
    end
    @summary, @could, @couldnt, @parts_to_purchase, @days_to_assemble = Contract.date_report( @date )
  end

  def contracts_update()
    @user = current_user
    cs = Contract.order( "ship_date DESC" ).where( shipped: false )
    cs.each do |c|
      could, couldnt, parts_to_purchase, days_to_assemble = c.contract_report()
      level = c.warning_level( could, couldnt, parts_to_purchase, days_to_assemble )
      c.warning = level
      if ( not c.save )
        redirect_to( contracts_path(), notice: 'Error: failed to recalculate contract statuses!' )
        return
      end
    end
    redirect_to( contracts_path(), notice: 'Contract statuses were successfully recalculated.' )
  end

  def copy()
    @user = current_user
    @contract = Contract.find( params[ :id ] )
    dest, err = copy_contract( @contract )
    if not dest
      redirect_to( contract_path( @contract.id ), notice: err )
    end

    redirect_to( contract_path( dest.id ), notice: 'Succeeded to copy this contract!' )
  end  

  def packing_list()
    @user = current_user
    @contract = Contract.find( params[ :id ] )

    #@contract_items = ContractItem.where( contract_id: params[ :id ] ) || []
    @contract_items = items_by_date( @contract, "number", params[:date] )
  end

  def user_packing_list()
    @user = current_user
    @contract = Contract.find( params[ :id ] )

    #@contract_items = ContractItem.where( contract_id: params[ :id ] ) || []
    @contract_items = items_by_date( @contract, "number", params[ :date ] )
  end

  def followup_packing_list()
    @user = current_user
    @contract = Contract.find( params[ :id ] )

    #@contract_items = ContractItem.where( contract_id: params[ :id ] ) || []
    @contract_items = items_by_date( @contract, "number", params[ :date ], true )
  end

  def inventory_packing_list()
    @user = current_user
    @contract = Contract.find( params[ :id ] )

    @contract_items = items_by_date( @contract, "number", params[:date] )
  end

  def ship_assigned_items()
    @user = current_user
    contract = Contract.find( params[ :id ] )
    date = params[ :date ]
    res, comment = create_shipment( contract, date )
    if ( not res )
      redirect_to edit_contract_path( contract.id ), notice: comment
      return
    end
    redirect_to contract_path( contract.id ), notice: "New shipment is created"
  end

  def add_attachment
    show()
    file = params[ :file ]
    desc = params[ :desc ]
    if ( @contract.add_attachment( file, desc ) )
      redirect_to( contract_path( @contract.id ), notice: "File has been added!" )
    else
      redirect_to( contract_path( @contract.id ), notice: "ERROR: Failed to add file!" )
    end
  end

  def change_number
    @user = current_user
    @contract = Contract.find( params[ :id ] )
    @contract_item = ContractItem.find( params[ :item ] )
  end

  def change_number_apply
    @user = current_user
    @contract = Contract.find( params[ :id ] )
    ci = ContractItem.find( params[ :item ] )
    ci.number = params[ :number ] || ci.number
    if ( ci.save )
      redirect_to( contract_path( @contract.id ), notice: "Number is changed successfully!" )
    else
      redirect_to( contract_path( @contract.id ), notice: "ERROR: Failed to change number!" )
    end
  end

  def add_ship_date
    @user = current_user
    @contract = Contract.find( params[ :id ] )
    event = params[:date]
    @date = Date.new( event["date(1i)"].to_i, event["date(2i)"].to_i, event["date(3i)"].to_i )
    sds = ShipDate.where( date: @date )
    if ( not sds ) || ( sds.size < 1 )
      ship_date = ShipDate.new
      ship_date.contract_id = @contract.id
      ship_date.date = @date
      res = ship_date.save
      if ( res )
       redirect_to( edit_contract_path( @contract.id ), notice: "Ship date is added successfully!" )
      else
        redirect_to( edit_contract_path( @contract.id ), notice: "ERROR: Failed to create ship date!" )
      end
    else
      redirect_to( edit_contract_path( @contract.id ), notice: "Ship date already exists!" )
    end
  end

  def set_ship_date
    @user          = current_user
    @contract      = Contract.find( params[ :id ] )
    @contract_item = ContractItem.find( params[ :item ] )
    @ship_dates    = @contract.ship_dates
  end

  def set_ship_date_apply
    @user = current_user
    @contract = Contract.find( params[ :id ] )
    @ci       = ContractItem.find( params[ :item ] )
    @sd       = ShipDate.find( params[ :date ] )
    @ci.ship_date_id = @sd.id
    res = @ci.save
    if res 
      redirect_to( contract_path( @contract.id ), notice: "Item is updated successfully!" )
    else
      redirect_to( contract_path( @contract.id ), notice: "ERROR: Failed to assign ship date to the item!" )
    end
  end

  def change_box
    @user  = current_user
    @contract = Contract.find( params[ :id ] )
    if ( params[:search] && (params[:search].size > 0) )
      @boxes = search( Box, params[:search], [ "box_id", "desc" ] )
      @paginate = false
    else
      @boxes = Box.paginate( page: params[ :page ], per_page: 30 )
      @paginate = true
    end
  end

  def change_box_apply
    @user  = current_user
    @contract = Contract.find( params[ :id ] )
    @contract.box_id = params[ :box_id ]
    if ( @contract.save )
      redirect_to @contract, notice: 'Default place for products is set successfully.'
    else
      redirect_to change_contract_box_path( @contract.id ), notice: 'Failed assign default place for products.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contract_params
      params.require(:contract).permit( :name, :desc, :ship_date, :shipped, 
                                        :date, :number, :owner_id, :box_id )
    end
end
