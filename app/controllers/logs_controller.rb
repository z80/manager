class LogsController < ApplicationController
  include UsersHelper
  before_action :set_log, only: [:show, :edit, :update, :destroy]

  # GET /logs
  # GET /logs.json
  def index
    @user = current_user
    if ( params[:search] && (params[:search].size > 0) )
      @logs = search( Log, params[:search], [ "msg" ] )
      @paginate = false
    else
      @logs = Log.paginate( page: params[ :page ], per_page: 100, order: "created_at desc" )
      @paginate = true
    end
  end

  # GET /logs/1
  # GET /logs/1.json
  #def show
  #end

  # GET /logs/new
  #def new
  #  @log = Log.new
  #end

  # GET /logs/1/edit
  #def edit
  #end

  # POST /logs
  # POST /logs.json
  def create
    @log = Log.new(log_params)

    respond_to do |format|
      if @log.save
        format.html { redirect_to @log, notice: 'Log was successfully created.' }
        format.json { render action: 'show', status: :created, location: @log }
      else
        format.html { render action: 'new' }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logs/1
  # PATCH/PUT /logs/1.json
  #def update
  #  respond_to do |format|
  #    if @log.update(log_params)
  #      format.html { redirect_to @log, notice: 'Log was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: 'edit' }
  #      format.json { render json: @log.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:msg)
    end
end
