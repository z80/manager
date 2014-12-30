class ProductsController < ApplicationController
  include UsersHelper
  include ProductStatusesHelper
  include LogsHelper
  include PartsHelper
  include ItemsHelper

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @user  = current_user
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @user  = current_user
    @product = Product.find( params[ :id ] )
    @prod_type = ProdType.find( @product.prod_type_id )
    if @prod_type
      @subproducts = @prod_type.subproducts
    end
    @owner = User.exists?( @product.owner_id ) ? User.find( @product.owner_id ) : nil
  end

  # GET /products/new
  def new
    @user  = current_user
    @product = Product.new
    @statuses = product_statuses
    @current_status = @product.status || 1

    @prod_type_id = params[ :prod_type_id ]
    @prod_type = ProdType.exists?( @prod_type_id ) ? ProdType.find( @prod_type_id ) : nil

    @part = @prod_type.part()
    @boxes = [ [ "none", -1 ] ]
    if ( @part )
      @create_new = true
      boxes = @part.boxes
      boxes.each do |box_part_inst|
        box  = box_part_inst[ :box ]
        inst = box_part_inst[ :inst ] 
        cnt  = inst.cnt
        if ( cnt > 0 )
          stri = "box \"#{box.box_id}\" (#{cnt})"
          @boxes.append( [ stri, inst.id ] )
        end
      end
    end

    @users = users
    @users.prepend( [ "None", -1 ] )
    @owner_id = params[ :owner_id ] || -1

    @make_new = true
  end

  # GET /products/1/edit
  def edit
    @user  = current_user
    @product = Product.find( params[ :id ] )
    @current_status = @product.status || 1
    @statuses = product_statuses

    @users = users
    @users.prepend( [ "None", -1 ] )
    @owner_id = @product.owner_id || -1

    @prod_type_id = @product.prod_type_id
    @prod_type = ProdType.exists?( @prod_type_id ) ? ProdType.find( @prod_type_id ) : nil
    if ( @prod_type )
      @subproducts = @prod_type.subproducts
    end

    @make_new = false

    box_id = params[ :box_id ] || -1
    @box = Box.exists?( box_id ) ? Box.find( box_id ) : nil
  end

  # POST /products
  # POST /products.json
  def create
    @user  = current_user
    @product = Product.new(product_params)
    @prod_type = ProdType.exists?( params[:product][:prod_type_id] ) ? 
                    ProdType.find( params[:product][:prod_type_id] ) : nil

    # If part_inst was chosen subtract from appropriate part_inst.
    part_inst_id = params[ :part_inst_id ]
    if ( PartInst.exists?( part_inst_id ) )
      pi = PartInst.find( part_inst_id )
      pi.cnt = pi.cnt - 1
      if ( not pi.save )
        redirect_to @prod_type, notice: 'ERROR: Failed to take part from a box!'
        return
      end
    end
    respond_to do |format|
      if @product.save
        log( "New product is added: " + @product.serial_number, @user )
        
        format.html { redirect_to @prod_type, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    @user  = current_user
    owner_id = product_params[ :owner_id ]
    if not (owner_id && (owner_id.to_i > 0))
      # To not choose box once again.
      @box_id = product_params[ :box_id ]
      respond_to do |format|
        format.html { redirect_to edit_product_path( @product.id ), notice: 'ERROR: It is necessary to provide a person in charge explicitly!!!' }
        format.json { head :no_content }
      end
      return
    end

    # Set box id and exactly in this order.
    product_params[ :box_id ] ||= @product.box_id

    respond_to do |format|
      if @product.update(product_params)
        @product.set_status( product_params[ :status ] )
        log( "Product is updated: " + @product.serial_number, @user )
        
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  #def destroy
  #  @user  = current_user
  #  @product.destroy
  #  respond_to do |format|
  #    format.html { redirect_to products_url }
  #    format.json { head :no_content }
  #  end
  #end

  def change_box
    @user  = current_user
    @product = Product.find( params[ :id ] )
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
    @product = Product.find( params[ :id ] )
    @product.box_id = params[ :box_id ]
    if ( @product.save )
      redirect_to @product, notice: 'Product was moved to a different place.'
    else
      redirect_to change_product_box_path( @product.id ), notice: 'Failed to move product to a different place.'
    end
  end

  def add_attachment
    show()
    file = params[ :file ]
    desc = params[ :desc ]
    if ( @product.add_attachment( file, desc ) )
      redirect_to( product_path( @product.id ), notice: "File has been added!" )
    else
      redirect_to( product_path( @product.id ), notice: "ERROR: Failed to add file!" )
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find( params[ :id ] )
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require( :product ).permit( :prod_type_id, :serial_number, 
                                         :desc, :status, :pack_to, 
                                         :box_id, :owner_id )
    end
end
