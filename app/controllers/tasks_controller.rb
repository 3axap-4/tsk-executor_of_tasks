class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :define_default_task_status, only: [:create]
  before_action :fill_clients, only: [:new, :edit]

  # GET /tasks
  # GET /tasks.json
  def index
    clients = Client.where("user_id = ?", current_user.id).select(:id).to_a
    if !clients.nil?
      @tasks = Task.includes(:client).includes(:task_status).where("client_id IN (?)",clients)
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.task_status_id = @default_task_status_id

    respond_to do |format|
      if @task.save
        params[:attachments]['source'].each do |a|
          @task_attachment = @task.attachments.create!(:source => a)
        end
        format.html { redirect_to @task, notice: 'Задача успешно создана.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Задача успешно изменена.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Задача успешно удалена.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :description, :client_id, 
        attachments_attributes: [:id, :post_id, :source])
    end

    def define_default_task_status
      status = Setting.find_by_name('default_task_type_id');
      @default_task_status_id = status.nil? ? nil : status.value
    end

    def fill_clients
      @clients = Client.where("user_id = ?", current_user.id)
    end

end