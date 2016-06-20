class TasksController < ApplicationController
  include TasksHelper
  include SettingsHelper

  #invalidauthenticitytoken solve
  protect_from_forgery with: :null_session

  before_action :check_sign_in, only: [:index, :show, :new, :edit, :create, :update, :destroy, :download_attachment]
  before_action :set_task, only:      [:show, :edit, :update, :destroy]
  #before_action :define_default_task_status, only: [:create]
  before_action :fill_clients, only: [:new, :edit]
  before_action :fill_statuses, only: [:new, :edit]

  # GET /tasks
  # GET /tasks.json
  def index
    clients = (current_user.is_admin?)? Client.all.select(:id).to_a : Client.where("user_id = ?", current_user.id).select(:id).to_a
    @tasks = Task.includes(:client).includes(:task_status).where("client_id IN (?)",clients)
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
    @comments = Comment.where("task_id = #{@task.id}")
    #Comment.find_by_task_id(@task.id)
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)   
    status =  default_task_status
    @task.task_status_id = (status.nil?)? nil : default_task_status.value

    respond_to do |format|
      if @task.save
        save_attachments
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
        save_attachments
        format.html { redirect_to @task, notice: 'Задача успешно изменена.' }
        format.json { render :show, status: :ok, location: @tasks }
      else
        format.html { render :edit}
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

  def download_attachment
    att = Attachment.find(params[:id])
    send_file att.source.path if !att.nil?   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      task = Task.find_by_id(params[:id])
      if(task.nil? || !is_task_belongs_current_user?(task))
        render_404
      else
        @task = task
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :description, 
        :client_id, :task_status_id, :price,
        attachments_attributes: [:id, :task_id, :source],
        comments_attributes: [:body])
    end

    #def define_default_task_status
    #  status = Setting.find_by_name('default_task_type_id');
    #  @default_task_status_id = status.nil? ? nil : status.value
    #end

    def fill_clients
      (current_user.is_admin?)? @clients = Client.all :
      @clients = Client.where("user_id = ?", current_user.id)
    end

    def fill_statuses
      @statuses = TaskStatus.all
    end

    def save_attachments 
      if(params.has_key?(:attachments_source) && params.has_key?(:attachments_name))
        params[:attachments_source].count.times do |a|
          @task_attachment = @task.attachments.create!(name: params[:attachments_name][a+1], source: params[:attachments_source][a])
        end
      end
    end

end