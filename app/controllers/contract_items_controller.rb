class ContractItemsController < ApplicationController
  include LogsHelper
  before_action :set_contract_item, only: [:show, :edit, :update, :destroy]

  # GET /contract_items
  # GET /contract_items.json
  def index
    @user = current_user
    @contract_items = ContractItem.all
  end

  # GET /contract_items/1
  # GET /contract_items/1.json
  def show
    @user = current_user
  end

  # GET /contract_items/new
  def new
    @user = current_user
    @contract_item = ContractItem.new
  end

  # GET /contract_items/1/edit
  def edit
    @user = current_user
  end

  # POST /contract_items
  # POST /contract_items.json
  def create
    @user = current_user
    @contract_item = ContractItem.new(contract_item_params)

    respond_to do |format|
      if @contract_item.save
        log( "New contract item is added", @user )

        format.html { redirect_to @contract_item, notice: 'Contract item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @contract_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @contract_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contract_items/1
  # PATCH/PUT /contract_items/1.json
  def update
    @user = current_user
    respond_to do |format|
      if @contract_item.update(contract_item_params)
        log( "Contract item is changed", @user )

        format.html { redirect_to @contract_item, notice: 'Contract item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contract_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contract_items/1
  # DELETE /contract_items/1.json
  #def destroy
  #  @contract_item.destroy
  #  respond_to do |format|
  #    format.html { redirect_to contract_items_url }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract_item
      @contract_item = ContractItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contract_item_params
      params.require(:contract_item).permit(:contract_id, :prod_type_id, :product_id)
    end
end
