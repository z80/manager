class PartInstsController < ApplicationController
  before_action :set_part_inst, only: [:show, :edit, :update, :destroy]

  include UsersHelper
  include PartsHelper
  include LogsHelper

  # GET /part_insts
  # GET /part_insts.json
  def index
    @user = current_user
    if params[ :search ] && (params[ :search ].length > 0) then
        @parts = search( Part, params[ :search ], ['own_id', 'third_id', 'desc'] )
        @part_insts = nil
        @parts.each do |part|
            pis = PartInst.where( part_id: part.id )
            if ( @part_insts ) then
                @part_insts = @part_insts + pis
            else
                @part_insts = pis
            end
        end
        @paginate = false
    else
        @part_insts = PartInst.paginate( page: params[ :page ], per_page: 10 )
        @paginate = true
    end
    @boxes      = Box.all
  end

  # GET /part_insts/1
  # GET /part_insts/1.json
  def show
    @user = current_user
  end

  # GET /part_insts/new
  def new
    @user  = current_user
    if ( params[ :search ] && (params[ :search ].length > 0) ) then
        @parts = search( Part, params[:search], [ 'own_id', 'third_id', 'desc' ] )
        @paginate_parts = false
    else
        @parts = Part.paginate( page: params[ :part_page ], per_page: 10 )
        @paginate_parts = true
    end
    @boxes = Box.paginate( page: params[ :box_page ], per_page: 10 )
    @paginate_boxes = true
    #@part_inst = PartInst.new
  end

  # GET /part_insts/1/edit
  def edit
    @user      = current_user
    @part_inst = PartInst.find( params[ :id ] )
  end

  # POST /part_insts
  # POST /part_insts.json
  def create
    @user = current_user
    @part_inst        = PartInst.new
    @part_inst.cnt    = params[ :cnt ]
    @part_inst.box_id  = params[ :box_id ]
    @part_inst.part_id = params[ :part_id ]

    if @part_inst.save
      log( "New part instance is created", @user )
      
      redirect_to @part_inst, notice: 'Part inst was successfully created.'
    else
        render action: 'new'
    end
  end

  # PATCH/PUT /part_insts/1
  # PATCH/PUT /part_insts/1.json
  def update
    @user = current_user
    respond_to do |format|
      if @part_inst.update(part_inst_params)
        log( "Part instance is adjusted", @user )
        
        format.html { redirect_to @part_inst, notice: 'Part inst was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @part_inst.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /part_insts/1
  # DELETE /part_insts/1.json
  def destroy
    @user = current_user
    @part_inst.destroy
    respond_to do |format|
      format.html { redirect_to part_insts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part_inst
      @part_inst = PartInst.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_inst_params
      if ( params && params[ :part_inst ] ) then
          params.require(:part_inst).permit(:part_id, :box_id, :cnt)
      end
    end
end
