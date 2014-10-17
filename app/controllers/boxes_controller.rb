class BoxesController < ApplicationController
  include UsersHelper
  include PartsHelper
  include LogsHelper

  before_action :set_box, only: [:show, :edit, :update, :destroy]

  # GET /boxes
  # GET /boxes.json
  def index
    @user = current_user
    if ( params[:search] && (params[:search].size > 0) )
      @boxes = search( Box, params[:search], [ "box_id", "desc" ] )
      @paginate = false
    else
      @boxes = Box.paginate( page: params[ :page ], per_page: 30 )
      @paginate = true
    end

    @warehouses = Warehouse.all
  end

  # GET /boxes/1
  # GET /boxes/1.json
  def show
    @user = current_user
    @box  = Box.find( params[ :id ] )
    @wh   = @box.warehouse

    @part_insts = PartInst.where( box_id: params[ :id ] )
    @parts = []
    @part_insts.each do |pi|
      part = Part.find( pi.part_id )
      @parts.append( {part: part, inst: pi} )
    end
  end

  # GET /boxes/new
  def new
    @user = current_user
    @box = Box.new
  end

  # GET /boxes/1/edit
  def edit
    @user = current_user
  end

  # POST /boxes
  # POST /boxes.json
  def create
    @user = current_user
    @box = Box.new(box_params)

    respond_to do |format|
      if @box.save
        log( "New box " + box_params[ :box_id ] + " is created", @user )

        format.html { redirect_to @box, notice: 'Box was successfully created.' }
        format.json { render action: 'show', status: :created, location: @box }
      else
        format.html { render action: 'new' }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boxes/1
  # PATCH/PUT /boxes/1.json
  def update
    @user = current_user
    respond_to do |format|
      if @box.update(box_params)
        log( "Box " + box_params[ :box_id ] + " is changed", @user )
        
        format.html { redirect_to @box, notice: 'Box was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boxes/1
  # DELETE /boxes/1.json
  def destroy
    @user = current_user
    log( "Box " + @box.box_id + " is destroyed", @user )
    @box.destroy
        
    respond_to do |format|
      format.html { redirect_to boxes_url }
      format.json { head :no_content }
    end
  end

  # content /boxes/1/content
  def content
      @user = current_user
      @box = Box::find( params[ :id ] )
      @part_insts = PartInst.where( box_id: params[ :id ] )
      @parts = []
      @part_insts.each do |pi|
        part = Part.find( pi.part_id )
        @parts.append( {part: part, inst: pi} )
      end
  end

  # This is an action.
  def merge_identical
      @user = current_user
      @box = Box::find( params[ :id ] )
      while true do
          @part_insts = @box.part_insts
          insts = []
          @part_insts.each do |pi|
            insts.append( {id: pi.id, cnt: pi.cnt, part_id: pi.part_id} )
          end
          iters = 0
          insts.each do |a|
              insts.each do |b|
                  if ((a != b) && ( a[:part_id] == b[:part_id] )) then
                      pi_a = PartInst.find( a.id )
                      pi_b = PartInst.find( b.id )
                      pi_a.cnt = a[:cnt] + b[:cnt]
                      pi_a.save
                      pi_b.delete
                      iters += 1
                      break
                  end
              end
              if ( iters > 0 ) then
                  break
              end
          end
          if ( iters == 0 ) then
              break
          end
      end
      redirect_to box_path( @box.id ), notice: 'Merge successfull.'
  end

  # /boxes/:id/add/:part
  def add
      @add = true
      @add_or_take = "Adding"
      @user = current_user
      @box = Box.find( params[ :id ] )
      @part_inst = PartInst.find( params[ :part ] )
      @part      = Part.find( @part_inst.part_id )
  end

  def add_apply
      cnt = params[ :cnt ].to_i
      @user = current_user
      @box = Box::find( params[ :id ] )
      @part_inst = PartInst.find( params[ :part ] )
      old_cnt = @part_inst.cnt
      @part_inst.cnt = @part_inst.cnt + cnt
      if ( @part_inst.save ) then
          log( "Parts cnt is changed from " + old_cnt.to_s + " to " + cnt.to_s + " in box " + @box.box_id, @user )
          redirect_to inspect_content_path( @box.id ), notice: "#{cnt} parts\'ve been added sucessfully!"
      else
          render take_part_insts_path, notice: "Failed to add #{cnt} items to this box!"
      end
  end

  # /boxes/:id/take/:part
  def take
      @add = false
      @add_or_take = "Taking"
      @user = current_user
      @box = Box.find( params[ :id ] )
      @part_inst = PartInst.find( params[ :part ] )
      @part      = Part.find( @part_inst.part_id )
      #@cnt_max   = @part_inst.cnt
      #@cnt_min   = ( @cnt_max > 0 ) ? 1 : 0
  end

  def take_apply
      cnt = params[ :cnt ].to_i
      @user = current_user
      @box = Box::find( params[ :id ] )
      @part_inst = PartInst.find( params[ :part ] )
      if ( cnt > @part_inst.cnt ) then
          render take_part_insts_path, notice: "Failed to get #{cnt} pieces, too few items (#{@part_inst.cnt}) available!"
          return
      end
      old_cnt = @part_inst.cnt
      @part_inst.cnt = @part_inst.cnt - cnt
      if ( @part_inst.save ) then
          log( "Parts cnt is changed from " + old_cnt.to_s + " to " + cnt.to_s + " in box " + @box.box_id, @user )

          redirect_to inspect_content_path( @box.id ), notice: "#{cnt} parts\'ve been taken sucessfully!"
      else
          render take_part_insts_path, notice: "Failed to get #{cnt} items form this box!"
      end
  end

  def add_new_part
    @user = current_user
    @box  = Box.find( params[ :id ] )
    if params[ :search ] then
      @parts    = search( Part, params[ :search ], ['own_id', 'third_id', 'desc'] )
      @paginate = false
    else
      @parts    = Part.paginate( page: params[ :page ], per_page: 10 )
      @paginate = true
    end
  end

  def add_new_part_apply
    part_inst = PartInst.new
    part_inst.box_id = params[ :id ]
    part_inst.part_id = params[ :part_id ]
    part_inst.cnt = params[ :cnt ]
    if ( part_inst.save ) then
      redirect_to box_path( params[:id], notice: "Added new part(s) to this box" )
    else
      redirect_to add_new_part_to_box_path( params[ :id ] ), notice: "Failed to add part(s) to this box"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_box
      @box = Box.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def box_params
        if params[:box] then
            params.require( :box ).permit( :box_id, :desc, :warehouse_id )
        end
    end

    def wh_list
        #@wh = options_from_collection_for_select( Warehouse.all, :id, :w_id )
        #return @wh
        return nil
    end
end
