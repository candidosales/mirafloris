class Admin::ClientsController < Admin::BaseController
  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
    respond_with @clients
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])
    respond_with @client
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new
    respond_with @client
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(params[:client])
    flash[:notice] = 'client foi criado com sucesso.' if @client.save
    respond_with @client, :location => admin_clients_path
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])
    flash[:notice] = 'client foi atualizado com sucesso.' if @client.update_attributes(params[:client])
    respond_with @client, :location => edit_admin_client_path(@client)
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    respond_with @client, :location => admin_clients_path
  end

end
