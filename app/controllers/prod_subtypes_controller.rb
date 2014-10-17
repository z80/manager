class ProdSubtypesController < ApplicationController
  before_action :set_prod_subtype, only: [:show, :edit, :update, :destroy]

  # GET /prod_subtypes
  # GET /prod_subtypes.json
  def index
    @prod_subtypes = ProdSubtype.all
  end

  # GET /prod_subtypes/1
  # GET /prod_subtypes/1.json
  def show
  end

  # GET /prod_subtypes/new
  def new
    @prod_subtype = ProdSubtype.new
  end

  # GET /prod_subtypes/1/edit
  def edit
  end

  # POST /prod_subtypes
  # POST /prod_subtypes.json
  def create
    @prod_subtype = ProdSubtype.new(prod_subtype_params)

    respond_to do |format|
      if @prod_subtype.save
        format.html { redirect_to @prod_subtype, notice: 'Prod subtype was successfully created.' }
        format.json { render action: 'show', status: :created, location: @prod_subtype }
      else
        format.html { render action: 'new' }
        format.json { render json: @prod_subtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prod_subtypes/1
  # PATCH/PUT /prod_subtypes/1.json
  def update
    respond_to do |format|
      if @prod_subtype.update(prod_subtype_params)
        format.html { redirect_to @prod_subtype, notice: 'Prod subtype was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @prod_subtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prod_subtypes/1
  # DELETE /prod_subtypes/1.json
  def destroy
    @prod_subtype.destroy
    respond_to do |format|
      format.html { redirect_to prod_subtypes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prod_subtype
      @prod_subtype = ProdSubtype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prod_subtype_params
      params.require(:prod_subtype).permit(:belongs_id, :contains_id)
    end
end
