class ContractsController < ApplicationController
  include UsersHelper
  include PartsHelper
  include ItemsHelper
  include ContractsHelper
  include LogsHelper

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
        @contracts = Contract.paginate( page: params[:page], per_page: 10, order: "ship_date DESC" )
      else
        @contracts = Contract.order( "ship_date DESC" ).where( shipped: false ).page( params[:page] )
      end
    end

    #@contracts = Contract.all
  end

  # GET /contracts/1
  # GET /contracts/1.json
  def show
    @user = current_user
    @contract = Contract.find( params[ :id ] )

    @contract_items = ContractItem.where( contract_id: params[ :id ] ) || []
    @could, @couldnt, @parts_to_purchase, @days_to_assemble = @contract.contract_report()
    @level = @contract.warning_level( @could, @couldnt, @parts_to_purchase, @days_to_assemble )
    if ( @contract.warning != @level )
      @contract.warning = @level
      @contract.save
    end
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
  end

  # GET /contracts/1/edit
  def edit
    @user = current_user
    @contract_items = ContractItem.where( contract_id: params[ :id ] ) || []
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
    @contract_item.product_id = nil
    @contract_item.save
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
    src = Contract.find( params[ :id ] )
    dest = Contract.new
    dest.name = src.name + " (copy)"
    dest.desc = src.desc
    dest.ship_date = src.ship_date
    dest.shipped   = src.shipped
    dest.warning   = src.warning
    if ( not dest.save )
      redirect_to( contract_path( src.id ), notice: 'Error: failed to copy this contract!' )
      return
    end

    cis = ContractItem.where( contract_id: src.id )
    cis.each do |ci|
      item = ContractItem.new
      item.contract_id  = dest.id
      item.prod_type_id = ci.prod_type_id
      if ( not item.save )
        redirect_to( contract_path( src.id ), notice: 'Error: failed to copy this contract!' )
        return
      end
    end

    redirect_to( contract_path( dest.id ), notice: 'Succeeded to copy this contract!' )
  end  

  def packing_list()
    @user = current_user
    @contract = Contract.find( params[ :id ] )

    @contract_items = ContractItem.where( contract_id: params[ :id ] ) || []
  end

  def user_packing_list()
    @user = current_user
    @contract = Contract.find( params[ :id ] )

    @contract_items = ContractItem.where( contract_id: params[ :id ] ) || []
  end

  def ship_assigned_items()
    @user = current_user
    contract = Contract.find( params[ :id ] )
    res, comment = create_shipment( contract )
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


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contract_params
      params.require(:contract).permit(:name, :desc, :ship_date, :shipped, :date)
    end
end
