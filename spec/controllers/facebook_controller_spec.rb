require 'spec_helper'

describe FacebookController do

  describe 'POST #update_settings' do
    context 'with a signed in user' do
      let(:user){ create(:user)}
      let(:fb_app){ create(:fb_app,:user => user) }
      before(:each) do
        sign_in user
      end

      it 'update settings of social_app' do
        SocialApp.any_instance.should_receive(:update_settings).with({'key' => 'value'})
        post :update_settings ,:settings => {'key' => 'value'},:id => fb_app.id
      end

      it 'renders json of retweeted tweet_id' do
        fb_app.stub(:update_settings).with({'key' => 'value'})
        post :update_settings ,:settings => {'key' => 'value'},:id => fb_app.id
        response.should redirect_to(social_app_path(fb_app))
      end

    end
  end

end
