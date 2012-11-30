class TwitterController < ApplicationController
  before_filter :authenticate_user!

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