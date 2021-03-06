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

      it 'redirect to show page' do
        fb_app.stub(:update_settings).with({'key' => 'value'})
        post :update_settings ,:settings => {'key' => 'value'},:id => fb_app.id
        response.should redirect_to(social_app_path(fb_app))
      end

    end
  end

  describe 'POST #like' do
    context 'with a signed in user' do
      let(:user){ create(:user) }
      let(:fb_app){ create(:fb_app,:user => user)}
      before(:each) do
        sign_in user
      end
      it 'should like the post' do
        SocialDash::Clients::FacebookClient.any_instance.should_receive(:like!).with('123').and_return(true)
        post :like, 'fb_object_id' => '123', :id => fb_app.id
      end
      it 'should render json' do
        SocialDash::Clients::FacebookClient.any_instance.should_receive(:like!).with('123').and_return(true)
        post :like, 'fb_object_id' => '123', :id => fb_app.id
        response.body.should eq({'fb_object_id' => '123'}.to_json)
      end
    end
  end

  describe 'POST #comment' do
    context 'with a signed in user' do
      let(:user){ create(:user) }
      let(:fb_app){ create(:fb_app,:user => user)}
      before(:each) do
        sign_in user
      end
      it 'should comment the post' do
        fb_comment = mock(:fb_comment)
        fb_comment.stub(:identifier).and_return('1234')
        SocialDash::Clients::FacebookClient.any_instance.should_receive(:comment!).with('123','blah').and_return(fb_comment)
        post :comment, :comment => {'in_reply_to_id' => '123','text' => 'blah'}, :id => fb_app.id
      end
      it 'should render json with comment id' do
        fb_comment = mock(:fb_comment)
        fb_comment.stub(:identifier).and_return('1234')
        SocialDash::Clients::FacebookClient.any_instance.should_receive(:comment!).with('123','blah').and_return(fb_comment)
        post :comment, :comment => {'in_reply_to_id' => '123','text' => 'blah'}, :id => fb_app.id
        response.body.should eq({'fb_object_id' => '1234'}.to_json)
      end
    end
  end

  describe 'POST #block' do
    context 'with a signed in user' do
      let(:user){ create(:user)}
      let(:fb_app){ create(:fb_app,:user => user) }
      before(:each) do
        sign_in user
      end
      it 'should block user' do
        fb_results = [{'identifier' => '123'}]
        SocialDash::Clients::FacebookClient.any_instance.should_receive(:block!).with('123').and_return(fb_results)
        post :block, :id => fb_app.id, :user => {:identifier => '123'}
      end
      it 'should render json of blocked user' do
        fb_results = [{'identifier' => '123'}]
        SocialDash::Clients::FacebookClient.any_instance.stub(:block!).with('123').and_return(fb_results)
        post :block, :id => fb_app.id, :user => {:identifier => '123'}
        response.body.should eq(fb_results.to_json)
      end
    end
  end

  describe 'GET #blocking' do
    context 'with a signed in user' do
      let(:user){ create(:user)}
      let(:fb_app){ create(:fb_app,:user => user) }
      before(:each) do
        sign_in user
        SocialDash::Clients::FacebookClient.any_instance.stub(:blocked).and_return([1,2])
      end

      it 'assigns social app' do
        get :blocked, :id => fb_app.id
        assigns(:social_app).should eq(fb_app)
      end

      it 'assigns list of blocked users' do
        get :blocked, :id => fb_app.id
        assigns(:blocked_users).should eq([1,2])
      end

      it 'renders blocking page' do
        get :blocked, :id => fb_app.id
        response.should render_template 'social_apps/facebook/blocked'
      end

    end
  end
  describe 'POST #delete_comment' do
    context 'with a signed in user' do
      let(:user){ create(:user)}
      let(:fb_app){ social_app = create(:fb_app,:user => user) }
      before(:each) do
        sign_in user
      end

      it 'deletes posted comment_id' do
        SocialDash::Clients::FacebookClient.any_instance.should_receive(:delete_comment).with('111').and_return(true)
        post :delete_comment ,:comment_id => '111',:id => fb_app.id
      end

      it 'renders json of retweeted tweet_id' do
        SocialDash::Clients::FacebookClient.any_instance.stub(:delete_comment).and_return(true)
        post :delete_comment , :comment_id => '111',:id => fb_app.id
        response.body.should eq({:comment_id => '111'}.to_json)
      end

    end
  end


end
