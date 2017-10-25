class FilesController < ApplicationController
  load_and_authorize_resource

  def create
    # 浮动窗口上传
    @file = file.new
    @file.image = params[:file]
    if @file.image.blank?
      render json: { ok: false }, status: 400
      return
    end

    @file.user_id = current_user.id
    if @file.save
      render json: { ok: true, url: @file.image.url(:large) }
    else
      render json: { ok: false }
    end
  end
end
