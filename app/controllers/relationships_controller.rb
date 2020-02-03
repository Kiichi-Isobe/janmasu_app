class RelationshipsController < ApplicationController
  before_action :require_login
  before_action :redirect_test_user

  def create
    @user = User.find(params[:following_id])
    if current_user == @user || current_user.following?(@user)
      redirect_to root_url
    else
      current_user.follow!(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    end
  end

  def destroy
    @user = User.find(params[:following_id])
    if current_user == @user
      redirect_to root_url
    else
      current_user.unfollow!(@user)
      @user.unfollow!(current_user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    end
  end
end
