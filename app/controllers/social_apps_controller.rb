class SocialAppsController < ApplicationController

  def index
    @social_apps = current_user.social_apps
  end

  def create
    app = current_user.social_apps.create_from_omniauth(env["omniauth.auth"])
    redirect_to app, :notice => 'Successfully added Social App'
  end

  def show
    
  end
end
