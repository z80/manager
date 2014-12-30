class PartsController < ApplicationController
  include UsersHelper
  include PartsHelper
  include ItemsHelper
  include PartTypesHelper
  include LogsHelper
  include ContractsHelper

  before_action :set_part, only: [:show, :edit, :update, :destroy]

  # GET /parts
  # GET /parts.json
  def index
    @user = current_user
    if ( params[ :search ] ) then
      @paginate = false
      @parts = search( Part, params[ :search ], [ 'own_id', 'third_id', 'desc' ] )
    else
      @paginate = true
      @parts = Part.paginate( page: params[:page], per_page: 10 )
    end
  end

  # GET /parts/1
  # GET /parts/1.json
  def show
    @user = current_user
    @part = Part.find( params[ :id ] )
    @parts = @part.all_subparts
    @superparts = @part.all_superparts
    params[ :expand ] ||= "false"
    @expand     = params[ :expand ].to_bool
  end

  def add_image
    show()
    img  = params[ :image ]
    desc = params[ :desc ]
    if ( @part.add_image( image, desc ) )
      redirect_to( part_path( @part.id ), notice: "Image has been added!" )
    else
      redirect_to( part_path( @part.id ), notice: "ERROR: Failed to add image!" )
    end
  end

  def add_attachment
    show()
    file = params[ :file ]
    desc = params[ :desc ]
    if ( @part.add_attachment( file, desc ) )
      redirect_to( part_path( @part.id ), notice: "File has been added!" )
    else
      redirect_to( part_path( @part.id ), notice: "ERROR: Failed to add file!" )
    end
  end

  def show_production
    #debugger
    @user = current_user
    @part = Part.find( params[ :id ] )
    @cnt  = params[ :cnt ] || 1
    @cnt = @cnt.to_i
    @type = (params[ :type ]) ? params[ :type ].to_i : -1
    @exclude_ordered = params[ :exclude_ordered ] ? true : false

    params[ :only_missing ] = ( params[ :only_missing ] ) ? params[ :only_missing ].to_bool : false
    @parts, cp = ( params[ :only_missing ] ) ? 
                    parts_missing( @part, @type, @cnt, exclude_ordered: @exclude_ordered ) : 
                    parts_needed( @part, @type, @cnt )
    @price = total_price( @parts ).to_i
    users()
    @only_missing = params[ :only_missing ]
    @part_types = part_types
    @part_types.prepend( [ "Any", -1 ] )
    @contracts = active_contracts
    @contracts.prepend( [ "None", -1 ] )
    @statuses = statuses
    
    if ( params[ :todo ] == "Order" ) then
      if ( order_parts( @parts ) )
        redirect_to( items_path, notice: "Order has been successfully placed!" )
      else
        redirect_to( show_production_path( @part.id ), notice: "Failed to create an order!" )
      end
    end
  end

  def bom
    @user = current_user
    @part = Part.find( params[ :id ] )
    @parts, cp = parts_needed( @part, -1, 1 )
  end


  def show_production_submit

  end

  # GET /parts/new
  def new
    @user = current_user
    @users = User.all
    @part = Part.new
    @part.user_id = @user.id
    @part_types = part_types
    @ordering_person_id = @user.id
    @users = users
    @users.prepend( [ 'None', -1 ] )
  end

  # GET /parts/1/edit
  def edit
    @user  = current_user
    @users = User.all
    @part_types = part_types
    @ordering_person_id = @part.ordering_person_id || @user.id
    @users = users
    @users.prepend( [ 'None', -1 ] )
  end

  # POST /parts
  # POST /parts.json
  def create
    @user  = current_user
    @users = User.all
    @part  = Part.new(part_params)
    @part.user_id  = @user.id
    @part_types = part_types
    if ( params[ :part ] ) then
        @part.own_id   = params[ :part ][ :own_id ]
        @part.third_id = params[ :part ][ :third_id ]
        @part.desc     = params[ :part ][ :desc ]
        @part.min_cnt  = params[ :part ][ :min_cnt ] || 0
        @part.order_link = params[ :part ][ :order_link ]
        @part.order_price  = params[ :part ][ :order_price ]
        @part.order_desc  = params[ :part ][ :order_desc ]
        if params[ :part ][ :image ] then
            @part.image = params[ :part ][ :image ]
        end
        @part.part_type  = params[ :part ][ :part_type ]
        @part.order_time = params[ :part ][ :order_time ]
    end
    respond_to do |format|
      if @part.save
        log( "New part type is created: " + @part.own_id + ", " + @part.third_id , @user )
      
        format.html { redirect_to @part, notice: 'Part was successfully created.' }
        format.json { render action: 'show', status: :created, location: @part }
      else
        format.html { render action: 'new' }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parts/1
  # PATCH/PUT /parts/1.json
  def update
    @user  = current_user
    @users = User.all
    @part.own_id   = params[ :part ][ :own_id ]
    @part.third_id = params[ :part ][ :third_id ]
    @part.desc     = params[ :part ][ :desc ]
    @part.min_cnt  = params[ :part ][ :min_cnt ] || 0
    @part.order_link = params[ :part ][ :order_link ]
    @part.order_price  = params[ :part ][ :order_price ]
    @part.order_desc  = params[ :part ][ :order_desc ]
    if params[ :part ][ :image ] then
      @part.image = params[ :part ][ :image ]
    end
    @part_types = part_types
    @part.part_type  = params[ :part ][ :part_type ]
    @part.order_time = params[ :part ][ :order_time ]
    respond_to do |format|
      if @part.update(part_params)
        log( "Part type is changed: " + @part.own_id + ", " + @part.third_id , @user )

        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parts/1
  # DELETE /parts/1.json
  #def destroy
  #  @user = current_user
  #  @part.destroy
  #  respond_to do |format|
  #    format.html { redirect_to parts_url }
  #    format.json { head :no_content }
  #  end
  #end

  def add_subparts
      @user  = current_user
      @part  = Part.find( params[ :id ] )
      #@parts = Part.all( :conditions => ["id != ?", @part.id] )
      if ( params[ :search ] ) then
          @paginate = false
          pts = search( Part, params[ :search ], [ 'own_id', 'third_id', 'desc' ] )
          @parts = []
          pts.each do |part|
              if ( part.id != @part.id ) then
                  @parts.append( part )
              end
          end
      else
          @paginate = true
          @parts = Part.paginate( page: params[:page], per_page: 10 )
      end
  end

  def add_subparts_apply
      @user  = current_user
      @part  = Part.find( params[ :id ] )
      sp = Subpart.new    
      sp.belongs_id  = @part.id
      sp.contains_id = params[ :part_id ]
      sp.cnt         = params[ :cnt ]
      if ( sp.save ) then
          log( "Subpart is added to part " + @part.own_id, @user )

          #format.html { redirect_to show_part_path( @part ), notice: 'Part was successfully updated.' }
          #puts part_path( params[ :id ] )
          redirect_to part_path( params[ :id ] ), notice: 'Part was successfully updated.'
      else
          render action: 'add_subparts'
      end
  end

  def remove_subparts
      @user  = current_user
      @part  = Part.find( params[ :id ] )
      @subparts = Subpart.where( belongs_id: @part.id )
  end

  def remove_subparts_apply
      @user  = current_user
      @part  = Part.find( params[ :id ] )
      sp = Subpart.find( params[ :subpart_id ] )
      if ( sp.delete ) then
          log( "Subpart is removed from part " + @part.own_id, @user )

          redirect_to part_path( params[ :id ] ), notice: 'Part was successfully updated.'
      else
          render action: 'remove_subparts'
      end
  end

  def estimate
    @user = current_user

    @part = Part.find( params[ :id ] )
    @cnt = params[ :cnt ].to_i || 1
    if ( @cnt < 1 )
      @cnt = 1
    end
    @available, @needed = @part.insts_to_take_from( @cnt )
    @missing   = @part.parts_missing( @cnt )
  end

  def estimate_take
    @part = Part.find( params[ :id ] )
    @cnt = params[ :cnt ].to_i || 1
    if ( @cnt < 1 ) then
      @cnt = 1
    end
    available, needed = @part.insts_to_take_from( @cnt )
    #debugger
    if ( params[ :take_id ] == "all" ) then
      available.each do |pi_cnt|
        pi  = pi_cnt[ :pi ]
        cnt = pi_cnt[ :cnt ]
        pi.cnt -= cnt
        if ( !pi.save ) then
          redirect_to estimate_path( params[ :id ], cnt: @cnt ), notice: "ERROR: Failed to take from a box!"
          return
        end
        log( "Parts are taken from warehouse: " + cnt.to_s + ", part type: " + pi.part.own_id , @user )
      end
      redirect_to estimate_path( params[ :id ], cnt: @cnt ), notice: 'All available part(s) was/were successfully taken from a warehouse!'
      return
    else
      take_id  = params[ :take_id ].to_i
      take_cnt = params[ :take_cnt ].to_i
      pi = PartInst.find( take_id )
      pi.cnt -= take_cnt
      log( "Parts are taken from warehouse: " + take_cnt.to_s + ", part type: " + pi.part.own_id , @user )
      if ( pi.save ) then
        redirect_to estimate_path( params[ :id ], cnt: @cnt ), notice: 'Parts of selected type were successfully taken from a box!'
        return
      else
        redirect_to estimate_path( params[ :id ], cnt: @cnt ), notice: "ERROR: Failed to take from a box!"
        return
      end
    end
    redirect_to estimate_path( params[ :id ], cnt: (@cnt || 1) ), notice: "STRANGE BEHAVIOR: Nothing has been taken!"
  end

  def add_image
    @user  = current_user
    part   = Part.find( params[ :id ] )
    image  = params[ :image ]
    desc   = params[ :desc ] || ''
    part.add_image( image, desc )
    redirect_to part, notice: 'Image is added to this part!'
  end

  def add_attachment
    @user  = current_user
    part   = Part.find( params[ :id ] )
    file  = params[ :file ]
    desc   = params[ :desc ] || ''
    part.add_attachment( file, desc )
    redirect_to part, notice: 'Attachement is added to this part!'
  end

  def copy()
    @user = current_user
    src   = Part.find( params[ :id ] )
    dest  = Part.new

    dest.own_id      = src.own_id   + " (copy)"
    dest.third_id    = src.third_id + " (copy)"
    dest.user_id     = @user.id
    dest.image       = src.image
    dest.desc        = src.desc     + " (copy)"
    dest.min_cnt     = src.min_cnt
    dest.order_link  = src.order_link
    dest.order_desc  = src.order_desc
    dest.order_price = src.order_price
    dest.part_type   = src.part_type
    dest.order_time  = src.order_time
    if ( not dest.save )
      log( "Part copy is created: " + part.own_id.to_s, @user )
      redirect_to( part_path( src.id ), notice: 'Error: failed to copy this part type!' )
      return
    end

    sps = Subpart.where( belongs_id: src.id )
    sps.each do |sp|
      item = Subpart.new
      item.belongs_id  = dest.id
      item.contains_id = sp.contains_id
      item.cnt         = sp.cnt
      if ( not item.save )
        redirect_to( part_path( src.id ), notice: 'Error: failed to copy this part type!' )
        return
      end
    end

    redirect_to( part_path( dest.id ), notice: 'Succeeded to copy this part type!' )
  end  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part
      @part = Part.find( params[:id] )
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_params
      params.require(:part).permit( :own_id, :third_id, :user_id, 
                                    :cnt, :image, :min_cnt, :order_link, 
                                    :order_desc, :order_price, :part_type, 
                                    :file, :order_time, :exclude_ordered, 
                                    :ordering_person_id )
    end
end





