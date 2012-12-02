class TwitterController < ApplicationController
  before_filter :authenticate_user!

  def update_settings
    @social_app = current_user.social_apps.find(params[:id])
    @social_app.update_settings(params[:settings])
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
end
