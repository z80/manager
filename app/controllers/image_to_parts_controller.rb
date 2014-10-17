class ImageToPartsController < ApplicationController
  before_action :set_image_to_part, only: [:show, :edit, :update, :destroy]

  # GET /image_to_parts
  # GET /image_to_parts.json
  def index
    @image_to_parts = ImageToPart.all
  end

  # GET /image_to_parts/1
  # GET /image_to_parts/1.json
  def show
  end

  # GET /image_to_parts/new
  def new
    @image_to_part = ImageToPart.new
  end

  # GET /image_to_parts/1/edit
  def edit
  end

  # POST /image_to_parts
  # POST /image_to_parts.json
  def create
    @image_to_part = ImageToPart.new(image_to_part_params)

    respond_to do |format|
      if @image_to_part.save
        format.html { redirect_to @image_to_part, notice: 'Image to part was successfully created.' }
        format.json { render action: 'show', status: :created, location: @image_to_part }
      else
        format.html { render action: 'new' }
        format.json { render json: @image_to_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /image_to_parts/1
  # PATCH/PUT /image_to_parts/1.json
  def update
    respond_to do |format|
      if @image_to_part.update(image_to_part_params)
        format.html { redirect_to @image_to_part, notice: 'Image to part was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image_to_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /image_to_parts/1
  # DELETE /image_to_parts/1.json
  def destroy
    @image_to_part.destroy
    respond_to do |format|
      format.html { redirect_to image_to_parts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_to_part
      @image_to_part = ImageToPart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_to_part_params
      params.require(:image_to_part).permit(:image_id, :part_id)
    end
end
