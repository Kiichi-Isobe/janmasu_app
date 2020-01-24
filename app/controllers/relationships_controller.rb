class RelationshipsController < ApplicationController
  before_action :require_login

  def create
    user = User.find(params[:following_id])
    if current_user.id == user.id || current_user.following?(user)
      redirect_to root_url
    else
      current_user.follow!(user)
      user.follow!(current_user)
      redirect_to user
    end
  end

  def destroy
    user = User.find(params[:following_id])
    if current_user.id == user.id || !current_user.following?(user)
      redirect_to root_url
    else
      current_user.unfollow!(user)
      user.unfollow!(current_user)
      redirect_to user
    end
  end
end
