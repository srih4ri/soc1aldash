class FacebookController < ApplicationController
  before_filter :authenticate_user!

  def update_settings
    @social_app = current_user.social_apps.find(params[:id])
    @social_app.update_settings(params[:settings])
    redirect_to @social_app
  end

  def like
    @social_app = current_user.social_apps.find(params[:id])
    @social_app.client_instance.like!(params[:fb_object_id])
    render :json => {:fb_object_id => params[:fb_object_id]}
  end

  def comment
    @social_app = current_user.social_apps.find(params[:id])
    comment = @social_app.client_instance.comment!(params[:comment][:in_reply_to_id],params[:comment][:text])
    render :json => {:fb_object_id => comment.identifier}
  end

  def block
    social_app = current_user.social_apps.find(params[:id])
    blocked_users = social_app.client_instance.block!(params[:user][:identifier])
    render :json => blocked_users
  end

  def blocked
    @social_app = current_user.social_apps.find(params[:id])
    @blocked_users = @social_app.client_instance.blocked
    render 'social_apps/facebook/blocked'
  end
end
