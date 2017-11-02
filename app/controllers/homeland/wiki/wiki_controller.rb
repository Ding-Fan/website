module Homeland::Wiki
  class WikisController < Homeland::Wiki::ApplicationController
    require_module_enabled! :wiki
    before_action :set_wiki, only: [:show, :edit, :update, :destroy, :comments]

    etag { Setting.wiki_sidebar_html }

    def index
      breadcrumb :wiki
      fresh_when(Setting.wiki_index_html)
    end

    def recent
      @wikis = wiki.recent.wiki(params[:wiki])
      fresh_when(@wikis)
    end

    def show
      if @wiki.blank?
        if current_user.blank?
          render_404
          return
        end

        redirect_to new_wiki_path(title: params[:id]), notice: 'wiki not Found, Please create a new wiki'
        return
      end

      breadcrumb :wiki_show, @wiki
      @wiki.hits.incr(1)
      fresh_when(@wiki)
    end

    def comments
      breadcrumb :wiki_comments, @wiki
      render_404 if @wiki.blank?
    end

    def new
      authorize! :create, wiki

      breadcrumb :wiki_new
      @wiki = wiki.new
      @wiki.slug = params[:title]
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @wiki }
      end
    end

    def edit
      authorize! :edit, @wiki
    end

    def create
      authorize! :create, wiki

      @wiki = wiki.new(wiki_params)
      @wiki.user_id = current_user.id
      @wiki.version_enable = true

      if @wiki.save
        current_user.points += 10
        redirect_to wiki_path(@wiki.title), notice: t('common.create_success')
      else
        render action: 'new'
      end
    end

    def update
      authorize! :update, @wiki

      @wiki.version_enable = true
      @wiki.user_id = current_user.id

      if @wiki.update(wiki_params)
        current_user.points += 5
        redirect_to wiki_path(@wiki.title), notice: t('common.update_success')
      else
        render action: 'edit'
      end
    end

    def preview
      render plain: Homeland::Markdown.call(params[:body])
    end

    protected

    def set_wiki
      @wiki = wiki.find_by_slug(params[:id])
    end

    def wiki_params
      params.require(:wiki).permit(:title, :body, :slug, :change_desc)
    end
  end
end
