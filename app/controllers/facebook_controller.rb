class FacebookController < ApplicationController
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
end
