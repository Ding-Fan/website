module Api
  module V3
    class FilesController < Api::V3::ApplicationController
      before_action :doorkeeper_authorize!

      # 上传图片,请使用 Multipart 的方式提交图片文件
      #
      # POST /api/v3/files
      #
      # @param file - 文件信息, [required]
      #
      # == returns
      # - image_url 图片 URL
      def create
        requires! :file

        @file = file.new
        @file.image   = params[:file]
        @file.user_id = current_user.id
        @file.save!
      end
    end
  end
end
