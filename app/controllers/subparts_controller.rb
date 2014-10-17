class SubpartsController < ApplicationController
  before_action :set_subpart, only: [:show, :edit, :update, :destroy]

  # GET /subparts
  # GET /subparts.json
  def index
    @subparts = Subpart.all
  end

  # GET /subparts/1
  # GET /subparts/1.json
  def show
  end

  # GET /subparts/new
  def new
    @subpart = Subpart.new
  end

  # GET /subparts/1/edit
  def edit
  end

  # POST /subparts
  # POST /subparts.json
  def create
    @subpart = Subpart.new(subpart_params)

    respond_to do |format|
      if @subpart.save
        format.html { redirect_to @subpart, notice: 'Subpart was successfully created.' }
        format.json { render action: 'show', status: :created, location: @subpart }
      else
        format.html { render action: 'new' }
        format.json { render json: @subpart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subparts/1
  # PATCH/PUT /subparts/1.json
  def update
    respond_to do |format|
      if @subpart.update(subpart_params)
        format.html { redirect_to @subpart, notice: 'Subpart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @subpart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subparts/1
  # DELETE /subparts/1.json
  def destroy
    @subpart.destroy
    respond_to do |format|
      format.html { redirect_to subparts_url }
      format.json { head :no_content }
    end
  end

  def add_image
    @user   = current_user
    subpart = Subpart.find( params[ :id ] )
    image   = params[ :image ]
    desc    = params[ :desc ] || ''
    subpart.add_image( image, desc )
    redirect_to subpart, notice: 'Image is added to this subpart!'
  end

  def add_attachment
    @user  = current_user
    subpart   = Subpart.find( params[ :id ] )
    file   = params[ :file ]
    desc   = params[ :desc ] || ''
    subpart.add_attachment( file, desc )
    redirect_to subpart, notice: 'Attachement is added to this subpart!'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subpart
      @subpart = Subpart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subpart_params
      params.require(:subpart).permit(:contains_id, :belongs_id)
    end
end
