class TwitterController < ApplicationController
  before_filter :authenticate_user!

  def update_settings
    @social_app = current_user.social_apps.find(params[:id])
    @social_app.update_settings(params[:settings])
    Rails.cache.clear("twitter_screen_name_#{@social_app.id}_#{Time.now.to_i/1000}")
    redirect_to @social_app
  end

  def retweet
    tweet = current_user.social_apps.find(params[:id]).client_instance.retweet(params[:tweet_id].to_i)
    render :json => tweet
  end

  def reply
    tweet = current_user.social_apps.find(params[:id]).client_instance.
      reply(params[:reply][:text],params[:reply][:in_reply_to_id].to_i)
    render :json => tweet
  end

  def search_results
    @social_app = current_user.social_apps.find(params[:id])
    @search_results = @social_app.client_instance.cached_search_results
    render 'social_apps/twitter/search_results'
  end

  def block
    @social_app = current_user.social_apps.find(params[:id])
    blocked_users = @social_app.client_instance.block(params[:user][:screen_name])
    if blocked_users.nil?
      render :json => {:error => "User Not found"},:status => 404
    else
      render :json => blocked_users
    end
  end

  def blocking
    @social_app = current_user.social_apps.find(params[:id])
    @blocked_users = @social_app.client_instance.blocking
    render 'social_apps/twitter/blocking'
  end

end
