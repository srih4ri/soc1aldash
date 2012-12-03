class SocialAppsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @social_apps = current_user.social_apps
  end

  def create
    app = current_user.social_apps.create_from_omniauth(env["omniauth.auth"])
    redirect_to settings_social_app_path(app), :notice => 'Successfully added Social App'
  end

  def show
    @social_app = current_user.social_apps.find(params[:id])
    @api = @social_app.client_instance
    render @social_app.provider
    @social_app.update_last_fetched_at!
  end

  def settings
    @social_app = current_user.social_apps.find(params[:id])
    render "social_apps/#{@social_app.provider}/settings"
  end

  def insights
    @social_app = current_user.social_apps.find(params[:id])
    render :json => @social_app.insights
  end
end
