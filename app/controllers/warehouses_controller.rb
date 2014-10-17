class WarehousesController < ApplicationController
  include UsersHelper
  before_action :set_warehouse, only: [:show, :edit, :update, :destroy]

  # GET /warehouses
  # GET /warehouses.json
  def index
      @user = current_user
      @warehouses = Warehouse.all
  end

  # GET /warehouses/1
  # GET /warehouses/1.json
  def show
      @user      = current_user
      @warehouse = Warehouse.find( params[ :id ] )
      @boxes     = @warehouse.boxes
  end

  # GET /warehouses/new
  def new
      @user = current_user
      @warehouse = Warehouse.new
  end

  # GET /warehouses/1/edit
  def edit
      @user = current_user
  end

  # POST /warehouses
  # POST /warehouses.json
  def create
    @user = current_user
    @warehouse = Warehouse.new(warehouse_params)
    if ( params[ :warehouse ] && params[ :warehouse ][ :image ] ) then
        @warehouse.image = params[ :warehouse ][ :image ]
    end

    respond_to do |format|
      if @warehouse.save
        format.html { redirect_to @warehouse, notice: 'Warehouse was successfully created.' }
        format.json { render action: 'show', status: :created, location: @warehouse }
      else
        format.html { render action: 'new' }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /warehouses/1
  # PATCH/PUT /warehouses/1.json
  def update
    @user = current_user
    if ( params[ :warehouse ] && params[ :warehouse ][ :image ] ) then
        @warehouse.image = params[ :warehouse ][ :image ]
    end
    respond_to do |format|
      if @warehouse.update(warehouse_params)
        format.html { redirect_to @warehouse, notice: 'Warehouse was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /warehouses/1
  # DELETE /warehouses/1.json
  def destroy
    @warehouse.destroy
    respond_to do |format|
      format.html { redirect_to warehouses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def warehouse_params
      params.require(:warehouse).permit(:w_id, :w_desc)
    end
end
