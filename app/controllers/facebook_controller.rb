class FacebookController < ApplicationController
  def update_settings
    @social_app = current_user.social_apps.find(params[:id])
    @social_app.update_settings(params[:settings])
    redirect_to @social_app
  end
end
