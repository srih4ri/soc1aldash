class TwitterController < ApplicationController
  before_filter :authenticate_user!

  def retweet
    tweet = current_user.social_apps.find(params[:id]).client_instance.retweet(params[:tweet_id].to_i)
    render :json => tweet
  end
end
