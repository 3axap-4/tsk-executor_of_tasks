class ClientsController < ApplicationController

  before_action :check_sign_in, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  # GET /clients
  # GET /clients.json
  def index
    if(current_user.is_admin?)
      @clients = Client.all
    else
      @clients = Client.where("user_id = ?", current_user.id)
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit

  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    @client.user_id = current_user.id

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Профиль успешно довален.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: 'Профиль успешно изменен.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Профиль успешно удален.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find_by_id(params[:id])

      if(@client.nil?)
        redirect_to action: "new"
      end
    
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :fio, :site, :description)
    end
end