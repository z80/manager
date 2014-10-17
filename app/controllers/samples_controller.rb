class SamplesController < ApplicationController
  include UsersHelper
  include ItemsHelper
  include LogsHelper

  before_action :set_sample, only: [:show, :edit, :update, :destroy]

  # GET /samples
  # GET /samples.json
  def index
    @user = current_user

    if ( params[ :search ] ) then
        @paginate = false
        @samples = search( Sample, params[ :search ], [ 'from', 'desc', 'location' ] )
    else
        @paginate = true
        @samples = Sample.paginate( page: params[:page], per_page: 10, order: "id DESC" )
    end
  end

  # GET /samples/1
  # GET /samples/1.json
  def show
    @user = current_user
  end

  # GET /samples/new
  def new
    @user = current_user
    @sample = Sample.new
    @users = users
  end

  # GET /samples/1/edit
  def edit
    @user = current_user
    @users = users

    params[ :warn_days ] = 7

    @status = []
    Sample.status_list().each do |k, v|
      @status.append( [v, k] )
    end

  end

  # POST /samples
  # POST /samples.json
  def create
    @user = current_user
    @sample = Sample.new(sample_params)
    @sample.user_placed = @user.id

    respond_to do |format|
      if @sample.save
        log( "New sample is added: " + @sample.desc, @user )

        format.html { redirect_to @sample, notice: 'Sample was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sample }
      else
        format.html { render action: 'new' }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /samples/1
  # PATCH/PUT /samples/1.json
  def update
    @user = current_user
    respond_to do |format|
      if @sample.update( sample_params )
        log( "New sample is updated: " + @sample.desc, @user )

        format.html { redirect_to @sample, notice: 'Sample was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /samples/1
  # DELETE /samples/1.json
  #def destroy
  #  @user = current_user
    #@sample.destroy
  #  respond_to do |format|
  #    format.html { redirect_to samples_url }
  #    format.json { head :no_content }
  #  end
  #end

  def add_image
    @user = current_user
    sample = Sample.find( params[ :id ] )
    image  = params[ :image ]
    desc   = params[ :desc ] || ''
    sample.add_image( image, desc )
    redirect_to sample, notice: 'Image is added to this sample!'
  end

  def change_box
    @user  = current_user
    @sample = Sample.find( params[ :id ] )
    if ( params[:search] && (params[:search].size > 0) )
      @boxes = search( Box, params[:search], [ "box_id", "desc" ] )
      @paginate = false
    else
      @boxes = Box.paginate( page: params[ :page ], per_page: 30 )
      @paginate = true
    end
  end

  def change_box_apply
    @user  = current_user
    @sample = Sample.find( params[ :id ] )
    @sample.box_id = params[ :box_id ]
    if ( @sample.save )
      redirect_to @sample, notice: 'The sample was moved to a different place.'
    else
      redirect_to change_sample_box_path( @product.id ), notice: 'Failed to move the sample to a different place.'
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sample_params
      params.require(:sample).permit( :from, :desc, :received, :due, :user_placed, 
                                      :user_resp, :status, :warn_days, :location, :box_id )
    end
end
