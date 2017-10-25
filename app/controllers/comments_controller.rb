class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.user.points < 1
      set_flash_message(:error, 'Your points are not enough')
    else
      @comment.user.points -= 1
      @success = @comment.user.save && @comment.save
    end
  end

  def edit
  end

  def update
    if @comment.update(params[:comment].permit!)
      redirect_to admin_comments_path(@admin_comment), notice: "Comment was successfully updated."
    else
      render action: "edit"
    end
  end

  def comment_params
    params.require(:comment).permit(:commentable_type, :commentable_id, :body)
  end
end
