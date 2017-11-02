class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.user.points < 1
      redirect_to comment_path(@comment), error: 'Your points are not enough'
    else
      @comment.type = 1
      @comment.status = 1
      current_user.points -= 1
      @success = @comment.user.save && @comment.save
    end
  end

  def edit
  end

  def update
    if @comment.update(params[:comment].permit!)
      @comment.edited += 1
      redirect_to comments_path(@comment), notice: 'Comment was successfully updated.'
    else
      render action: "edit"
    end
  end

  def comment_params
    params.require(:comment).permit(:commentable_type, :commentable_id, :body)
  end
end
