class ProdTypesController < ApplicationController
  include UsersHelper
  include PartsHelper
  include LogsHelper

  before_action :set_prod_type, only: [:show, :edit, :update]

  # GET /prod_types
  # GET /prod_types.json
  def index
    if ( params[ :search ] && (params[ :search ].size > 0) ) then
      @paginate   = false
      @prod_types = search( ProdType, params[ :search ], [ 'own_id', 'desc' ] )
    else
      @paginate   = true
      @prod_types = ProdType.paginate( page: params[:page], per_page: 10, order: "id DESC" )
    end
    @user  = current_user
    #@prod_types = ProdType.all
  end

  # GET /prod_types/1
  # GET /prod_types/1.json
  def show
    @user           = current_user
    @prod_type      = ProdType.find( params[ :id ] )
    search          = params[ :search ]
    @products, @paginate = @prod_type.products( params.to_hash, search, params[ :page ] )
    
    @subproducts = @prod_type.subproducts
  end

  # GET /prod_types/new
  def new
    @prod_type = ProdType.new
    if ( params[ :search ] && (params[ :search ].size > 0) ) then
      @paginate = false
      @parts    = search( Part, params[ :search ], [ 'own_id', 'third_id', 'desc' ] )
    else
      @paginate = true
      @parts    = Part.paginate( page: params[:page], per_page: 10 )
    end

    @user  = current_user
  end

  # GET /prod_types/1/edit
  def edit
    @user  = current_user
    @prod_type = ProdType.find( params[ :id ] )
    if ( params[ :search ] && (params[ :search ].size > 0) ) then
      @paginate = false
      @parts    = search( Part, params[ :search ], [ 'own_id', 'third_id', 'desc' ] )
    else
      @paginate = true
      @parts    = Part.paginate( page: params[:page], per_page: 10 )
    end

    @subproducts = @prod_type.subproducts
  end

  # POST /prod_types
  # POST /prod_types.json
  def create
    @user  = current_user
    #debugger
    @prod_type         = ProdType.new(prod_type_params)
    @prod_type.user_id = @user.id
    @prod_type.part_id = params[ :part_id ] || -1
    @prod_type.image   = params[ :prod_type ][ :image ]
    @prod_type.packing_details = params[ :prod_type ][ :packing_details ]

    respond_to do |format|
      if @prod_type.save
        log( "New product type is created: " + @prod_type.own_id, @user )

        format.html { redirect_to @prod_type, notice: 'Prod type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @prod_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @prod_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prod_types/1
  # PATCH/PUT /prod_types/1.json
  def update
    @user                      =   current_user
    @prod_type.part_id         = params[ :part_id ]  || @prod_type.part_id || -1
    @prod_type.image           = params[ :prod_type ][ :image ] || @prod_type.image
    @prod_type.packing_details = params[ :prod_type ][ :packing_details ] || @prod_type.packing_details
    respond_to do |format|
      if @prod_type.update(prod_type_params)
        log( "Product type is adjusted: " + @prod_type.own_id, @user )

        format.html { redirect_to @prod_type, notice: 'Prod type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @prod_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prod_types/1
  # DELETE /prod_types/1.json
  #def destroy
  #  @user  = current_user
  #  @prod_type.destroy
  #  respond_to do |format|
  #    format.html { redirect_to prod_types_url }
  #    format.json { head :no_content }
  #  end
  #end

  def add_subtype
    @user      = current_user
    @prod_type = ProdType.find( params[ :id ] )
    
    stri     = params[ :search ]
    if ( stri && ( stri.size > 0 ) )
      @prod_types = search( ProdType, stri, ['own_id', 'desc'] )
    else
      @prod_types = ProdType.all.page( params[:page] )
    end
  end

  def add_subtype_apply
    @user      = current_user
    @prod_type = ProdType.find( params[ :id ] )

    pst = ProdSubtype.new
    pst.belongs_id  = @prod_type.id
    pst.contains_id = params[ :contains_id ]
    if pst.save
      redirect_to( edit_prod_type_path( @prod_type.id ), notice: 'Successfully added product subtype.' )
    else
      redirect_to( edit_prod_type_path( @prod_type.id ), notice: 'Failed to add product subtype.' )
    end
  end

  def remove_subtype_apply
    @user      = current_user
    @prod_type = ProdType.find( params[ :id ] )
    pst = ProdSubtype.find( params[ :subtype_id ] )

    pst.delete
    pst.save
    redirect_to( edit_prod_type_path( @prod_type.id ), notice: 'Removed product type internal part.' )
  end

  def adjust
    @user      = current_user
    @prod_type = ProdType.find( params[ :id ] )
    part_id    = params[ :part_id ] || -1
    @prod_type.part_id = part_id
    @prod_type.save

    redirect_to( edit_prod_type_path( @prod_type.id ), notice: 'Removed product type internal part.' )
  end

  def add_attachment
    show()
    file = params[ :file ]
    desc = params[ :desc ]
    if ( @prod_type.add_attachment( file, desc ) )
      redirect_to( prod_type_path( @prod_type.id ), notice: "File has been added!" )
    else
      redirect_to( prod_type_path( @prod_type.id ), notice: "ERROR: Failed to add file!" )
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prod_type
      @prod_type = ProdType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prod_type_params
      params.require( :prod_type ).permit( :part_id, :own_id, :desc, :image, 
                                           :client_visible, :packing_details, :pack_to )
    end
end
