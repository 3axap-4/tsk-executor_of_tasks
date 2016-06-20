class CommentsController < ApplicationController

	before_action :check_sign_in, only: [:create]
	before_action :set_task, only: [:create]

	def create
		@comment = Comment.new(comment_params)
		@comment.task_id = @task.id
		@comment.user_id = current_user.id
		respond_to do |format|
			if @comment.save
			  format.html { redirect_to @comment, notice: 'comment was successfully created.' }
			  format.js
			else
			  format.html { render action: "new" }
			  format.json { render json: @comment.errors, status: :unprocessable_entity }
			end
		end
	end

	private

	def comment_params
		params.require(:comment).permit(:body)
	end

	def set_task 

		if (!params.has_key?(:task_id) ||
					  !Task.exists?(id: params[:task_id]))
			render_404
		else
		 	@task = Task.find(params[:task_id])
		 	if(@task.client.user_id != current_user.id && !current_user.is_admin?)
		 		render_404
		 	end
		end					
	end

end
