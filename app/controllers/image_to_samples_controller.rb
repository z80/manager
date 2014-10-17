class ImageToSamplesController < ApplicationController
  before_action :set_image_to_sample, only: [:show, :edit, :update, :destroy]

  # GET /image_to_samples
  # GET /image_to_samples.json
  def index
    @image_to_samples = ImageToSample.all
  end

  # GET /image_to_samples/1
  # GET /image_to_samples/1.json
  def show
  end

  # GET /image_to_samples/new
  def new
    @image_to_sample = ImageToSample.new
  end

  # GET /image_to_samples/1/edit
  def edit
  end

  # POST /image_to_samples
  # POST /image_to_samples.json
  def create
    @image_to_sample = ImageToSample.new(image_to_sample_params)

    respond_to do |format|
      if @image_to_sample.save
        format.html { redirect_to @image_to_sample, notice: 'Image to sample was successfully created.' }
        format.json { render action: 'show', status: :created, location: @image_to_sample }
      else
        format.html { render action: 'new' }
        format.json { render json: @image_to_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /image_to_samples/1
  # PATCH/PUT /image_to_samples/1.json
  def update
    respond_to do |format|
      if @image_to_sample.update(image_to_sample_params)
        format.html { redirect_to @image_to_sample, notice: 'Image to sample was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image_to_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /image_to_samples/1
  # DELETE /image_to_samples/1.json
  def destroy
    @image_to_sample.destroy
    respond_to do |format|
      format.html { redirect_to image_to_samples_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_to_sample
      @image_to_sample = ImageToSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_to_sample_params
      params.require(:image_to_sample).permit(:image_id, :sample_id)
    end
end
