class ProductsController < ApplicationController
  include UsersHelper
  include ProductStatusesHelper
  include LogsHelper
  include PartsHelper

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
  end

  # GET /products/new
  def new
    @user  = current_user
    @product = Product.new
    @statuses = statuses
    @current_status = @product.status || 1

    @prod_type_id = params[ :prod_type_id ]
    @prod_type = ProdType.exists?( @prod_type_id ) ? ProdType.find( @prod_type_id ) : nil
  end

  # GET /products/1/edit
  def edit
    @user  = current_user
    @product = Product.find( params[ :id ] )
    @current_status = @product.status || 1
    @statuses = statuses

    @prod_type_id = @product.prod_type_id
    @prod_type = ProdType.exists?( @prod_type_id ) ? ProdType.find( @prod_type_id ) : nil
    if ( @prod_type )
      @subproducts = @prod_type.subproducts
    end
  end

  # POST /products
  # POST /products.json
  def create
    @user  = current_user
    @product = Product.new(product_params)
    @prod_type = ProdType.exists?( params[:product][:prod_type_id] ) ? 
                    ProdType.find( params[:product][:prod_type_id] ) : nil
                    
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
      params.require( :product ).permit( :prod_type_id, :serial_number, :desc, :status, :pack_to )
    end
end
