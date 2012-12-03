require 'spec_helper'

describe SocialAppsController do

  describe 'GET #index' do
    context 'with a signed in user' do
      let(:user){ create(:user)}

      before(:each) do
        sign_in user
      end

      it 'populates an array of social apps' do
        social_app = create(:social_app,:user => user)
        get :index
        assigns(:social_apps).should eq([social_app])
      end

      it 'renders :index view' do
        get :index
        response.should render_template :index
      end

    end
    context 'without a signed in user' do
      before do
        sign_out :user
      end
      it 'should redirect to sign in' do
        get :index
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #create' do
    context "with a signed in user" do
      let(:user){ create(:user)}

      before(:each) do
        stub_env_for_omniauth
        sign_in user
      end

      it "should add a social_app" do
        expect{
          get :create, :provider => 'prv'
        }.to change(user.social_apps,:count).by(1)
      end

      it "should redirect to the new social_app" do
        get :create, :provider => 'prv'
        response.should redirect_to settings_social_app_path(SocialApp.last)
      end
    end
  end
  describe '#GET #show' do
    context 'with a signed in user' do
      let(:user){ create(:user) }
      let(:social_app){ create(:twitter_app,:user => user) }
      before(:each) do
        sign_in user
      end
      it 'should assign social_app' do
        get :show,:id => social_app.id
        assigns(:social_app).should eq(social_app)
      end

      it 'should assign api' do
        get :show,:id => social_app.id
        assigns(:api).should be_instance_of(SocialDash::Clients::TwitterClient)
      end

      it 'should update last fetched at' do
        SocialApp.any_instance.should_receive(:update_last_fetched_at!)
        get :show,:id => social_app.id
      end

      it 'should 404 for another guys social app' do
        another_user = create(:user)
        another_app = create(:social_app,:user => another_user)
        expect{ get :show,:id => another_user.id }.to raise_error(ActiveRecord::RecordNotFound)
      end
      it "should render provider's tempalte" do
        get :show,:id => social_app.id
        response.should render_template :twitter
      end
    end
    context 'without a signed in user' do
      before do
        sign_out :user
      end
      it 'should redirect to sign in' do
        get :show,:id => 4
        response.should redirect_to(new_user_session_path)
      end
    end
  end
  describe '#GET #settings' do
    context 'with a signed in user' do
      let(:user){ create(:user) }
      let(:social_app){ create(:social_app,:user => user,:provider => 'facebook') }
      let(:twitter_app){ create(:twitter_app,:user => user)}
      before(:each) do
        sign_in user
      end
      it 'should assign api' do
        get :settings,:id => social_app.id
        assigns(:social_app).should eq(social_app)
      end
      it 'should 404 for another guys social app' do
        another_user = create(:user)
        another_app = create(:social_app,:user => another_user)
        expect{ get :settings,:id => another_user.id }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context 'for facebook app' do
        it "should render facebook's tempalte" do
          get :settings,:id => social_app.id
          response.should render_template 'social_apps/facebook/settings'
        end
      end
      context 'for twitter app' do
        it "should render twitter's template" do
          get :settings,:id => twitter_app.id
          response.should render_template 'social_apps/twitter/settings'
        end
      end
    end
    context 'without a signed in user' do
      before do
        sign_out :user
      end
      it 'should redirect to sign in' do
        get :settings,:id => 4
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #insights' do

    context 'with a signed in user' do
      let(:user){ create(:user) }
      let(:social_app){ create(:social_app,:user => user,:provider => 'facebook') }
      before(:each) do
        sign_in user
      end
      it 'should return json of insights' do
        SocialApp.any_instance.stub(:insights).and_return({:a => 1})
        get :insights,:id => social_app.id
        response.body.should eq({:a => 1}.to_json)
      end
    end
  end
end

def stub_env_for_omniauth
  env = {"omniauth.auth" =>  {'provider' => 'prv','uid' => 'alongstringwithtoomany','info' => {'name' => 'srihari'} } }
  @controller.stub!(:env).and_return(env)
end
