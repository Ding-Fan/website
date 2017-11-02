class UsersController < ApplicationController
  before_action :set_user, except: [:index, :city]

  etag { @user }

  include Users::UserActions

  def index
    @total_user_count = User.count
    @active_users = User.fields_for_list.hot.limit(100)
  end

  def show
    user_show
  end

  private

  def user_params
    params.require(:user).permit(:name, :tag_list) ## Rails 4 strong params usage
  end

  protected

  def set_user
    @user = User.find_by_username!(params[:id])

    # 转向正确的拼写
    if @user.username != params[:id]
      redirect_to user_path(@user.username), status: 301
      return
    end

    render_404 if @user.deleted?

    @user_type = @user.user_type
  end

  # Override render method to render difference view path
  def render(*args)
    options = args.extract_options!
    if @user_type
      options[:template] ||= "/#{@user_type.to_s.tableize}/#{params[:action]}"
    end
    super(*(args << options))
  end


end
