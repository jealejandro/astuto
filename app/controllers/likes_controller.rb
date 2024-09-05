class LikesController < ApplicationController
  before_action :set_anonymous_id, only: [:create, :destroy]
  before_action :check_tenant_subscription, only: [:create, :destroy]

  def index
    likes = Like
      .select(:id, :anonymous_id)
      .where(post_id: params[:post_id])

    render json: likes
  end

  def create
    like = Like.new(like_params)

    if like.save
      render json: {
        id: like.id,
        anonymous_id: like.anonymous_id,
      }, status: :created
    else
      render json: {
        error: like.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    like = Like.find_by(like_params)
    id = like&.id
    
    if like&.destroy
      render json: {
        id: id,
      }, status: :accepted
    else
      render json: {
        error: like&.errors&.full_messages || ["Like not found"]
      }, status: :unprocessable_entity
    end
  end

  private

    def like_params
      {
        post_id: params[:post_id],
        anonymous_id: @anonymous_id,
      }
    end

    def set_anonymous_id
      @anonymous_id = session[:anonymous_id] ||= SecureRandom.uuid
    end
end
