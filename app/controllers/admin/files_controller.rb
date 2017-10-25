module Admin
  class FilesController < Admin::ApplicationController
    before_action :set_file, only: [:show, :destroy]

    def index
      @files = file.recent.includes(:user).page(params[:page])
    end

    def destroy
      @file.destroy
      redirect_to(admin_files_url)
    end

    private

    def set_file
      @file = file.find(params[:id])
    end
  end
end
