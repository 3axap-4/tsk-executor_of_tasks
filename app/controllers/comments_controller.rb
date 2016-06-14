class CommentsController < ApplicationController
	def create
		@comment = Comment.new(comment_params)
		@comment.task_id = params[:task_id]
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

end