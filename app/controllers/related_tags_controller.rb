class RelatedTagsController < ApplicationController
  respond_to :json, :xml, :js, :html, except: [:update]
  before_action :require_reportbooru_key, only: [:update]

  def show
    @query = RelatedTagQuery.new(params[:query], category: params[:category], translated_tags: params[:translated_tags], artists: params[:artists])
    respond_with(@query) do |format|
      format.json do
        render :json => @query.to_json
      end
    end
  end

  def update
    @tag = Tag.find_by_name(params[:name])
    @tag.related_tags = params[:related_tags]
    @tag.related_tags_updated_at = Time.now
    @tag.post_count = params[:post_count] if params[:post_count].present?
    @tag.save
    head :ok
  end

  protected

  def require_reportbooru_key
    unless Danbooru.config.reportbooru_key.present? && params[:key] == Danbooru.config.reportbooru_key
      raise User::PrivilegeError
    end
  end
end
