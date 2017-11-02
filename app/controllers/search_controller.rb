class SearchController < ApplicationController
  before_action :authenticate_user!, only: [:users]

  def index
    params[:q] ||= ""

    search_modules = [Topic, User]
    search_modules << Page if Setting.has_module?(:wiki)
    search_params = {
      query: {
        simple_query_string: {
          query: params[:q],
          default_operator: "AND",
          minimum_should_match: "70%",
          fields: %w(title body username)
        }
      },
      highlight: {
        pre_tags: ["[h]"],
        post_tags: ["[/h]"],
        fields: { title: {}, body: {}, username: {} }
      }
    }
    @result = Elasticsearch::Model.search(search_params, search_modules).page(params[:page])
  end

  def users
    @result = User.search(params[:q], user: current_user, limit: params[:limit] || 10)
    render json: @result.collect { |u| { username: u.username, avatar_url: u.large_avatar_url } }
  end
end
