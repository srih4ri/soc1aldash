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
        response.should redirect_to SocialApp.last
      end
    end
  end
  describe '#GET #show' do
    context 'with a signed in user' do
      let(:user){ create(:user) }
      let(:social_app){ create(:social_app,:user => user,:provider => 'twitter') }
      before(:each) do
        sign_in user
      end
      it 'should assign api' do
        get :show,:id => social_app.id
        assigns(:social_app).should eq(social_app)
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
  end
end

def stub_env_for_omniauth
  env = {"omniauth.auth" =>  {'provider' => 'prv','uid' => 'alongstringwithtoomany','info' => {'name' => 'srihari'} } }
  @controller.stub!(:env).and_return(env)
end
