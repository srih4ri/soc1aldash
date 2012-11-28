require 'spec_helper'

describe TwitterController do

  describe 'POST #retweet' do
    context 'with a signed in user' do
      let(:user){ create(:user)}
      let(:twitter_app){ social_app = create(:twitter_app,:user => user) }
      before(:each) do
        sign_in user
      end

      it 'retweets posted tweet_id' do
        SocialDash::Clients::TwitterClient.any_instance.should_receive(:retweet).with(111)
        post :retweet ,:tweet_id => '111',:id => twitter_app.id
      end

      it 'renders json of retweeted tweet_id' do
        SocialDash::Clients::TwitterClient.any_instance.stub(:retweet).and_return({:test => 1})
        post :retweet , :tweet_id => '111',:id => twitter_app.id
        response.body.should eq({:test => 1}.to_json)
      end

    end
  end

  describe 'POST #reply' do
    context 'with a signed in user' do
      let(:user){ create(:user)}
      let(:twitter_app){ social_app = create(:twitter_app,:user => user) }
      before(:each) do
        sign_in user
      end

      it 'retweets posted tweet_id' do
        SocialDash::Clients::TwitterClient.any_instance.should_receive(:reply).with('blah',111)
        post :reply, :reply => {:in_reply_to_id => '111',:text => 'blah'}, :id => twitter_app.id
      end

      it 'renders json of retweeted tweet_id' do
        SocialDash::Clients::TwitterClient.any_instance.stub(:reply).and_return({:id => 1})
        post :reply, :reply => {:in_reply_to_id => '111',:text => 'blah'}, :id => twitter_app.id
        response.body.should eq({:id => 1}.to_json)
      end
    end
  end

end
