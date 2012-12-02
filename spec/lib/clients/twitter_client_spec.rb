require 'spec_helper'

describe SocialDash::Clients::TwitterClient do

  describe '.settings_for' do
    it 'should return settings from oauth hash' do
      omniauth_hash = {'provider' => :twitter,'credentials' =>
        {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr',
          'secret' => 'ZhuIfIghQiLI2U8xmm1JYdd91qhpM8mQOrHBrius4z'}}
      settings = {'credentials' => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr',
          'secret' => 'ZhuIfIghQiLI2U8xmm1JYdd91qhpM8mQOrHBrius4z'},'search_terms' => '' }
      SocialDash::Clients::TwitterClient.settings_for(omniauth_hash).should eq(settings)
    end
  end

  describe '#initialize' do
    let(:settings) {{'credentials' => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr',
          'secret' => 'ZhuIfIghQiLI2U8xmm1JYdd91qhpM8mQOrHBrius4z'},'search_terms' => ['fu','bar'] }}
    let(:social_app) do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return(settings)
      social_app.stub(:id).and_return(10)
      social_app
    end
    let(:twt){SocialDash::Clients::TwitterClient.new(social_app)}
    it 'should set credentials' do
      twt.instance_variable_get('@credentials').should eq(settings['credentials'])
    end
    it 'should set search terms' do
      twt.instance_variable_get('@search_terms').should eq(['fu','bar'])
    end
    it 'should set cache_key' do
      twt.instance_variable_get('@cache_key').should eq(10)
    end
  end

  describe '#client' do
    it "should return an instance of twitter gem's client'" do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'credentials' => {}})
      social_app.stub(:id).and_return(10)
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      twt.client.should be_instance_of(Twitter::Client)
    end
  end

  describe '#mentions' do
    it "should delegate mentions to twitter gem" do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'credentials' => {}})
      social_app.stub(:id).and_return(10)
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.should_receive(:mentions_timeline).and_return([])
      twt.mentions
    end
  end

  describe '#cached_mentions' do
    it "should cache #mentions" do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'credentials' => {}})
      social_app.stub(:id).and_return(10)
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.stub(:mentions).and_return([])
      Rails.cache.clear
      twt.should_receive(:mentions)
      twt.cached_mentions
      twt.should_not_receive(:mentions)
      Rails.cache.should_receive(:fetch)
      twt.cached_mentions
    end
  end

  describe '#search_results' do
    context 'when search_terms is set' do
      it "should delegate search for given terms to twitter gem" do
        social_app = mock(:social_app)
        social_app.stub(:settings).and_return({'search_terms' => 'my company OR com','credentials' => {}})
        social_app.stub(:id).and_return(10)
        twt = SocialDash::Clients::TwitterClient.new(social_app)
        twtr_results = mock(:twtr_results)
        twtr_results.should_receive(:results).and_return([])
        Twitter::Client.any_instance.should_receive(:search).with('my company OR com').and_return(twtr_results)
        twt.search_results
      end
    end
    context 'when search_terms is not set' do
      it "should not hit twitter API" do
        social_app = mock(:social_app)
        social_app.stub(:settings).and_return({'search_terms' => [],'credentials' => {}})
        social_app.stub(:id).and_return(10)
        twt = SocialDash::Clients::TwitterClient.new(social_app)
        Twitter::Client.any_instance.should_not_receive(:search)
        twt.search_results
      end
    end
  end

  describe '#cached_search_results' do
    it "should cache #search_results" do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'credentials' => {}})
      social_app.stub(:id).and_return(10)
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.stub(:search_results).and_return([])
      Rails.cache.clear
      twt.should_receive(:search_results)
      twt.cached_search_results
      twt.should_not_receive(:search_results)
      Rails.cache.should_receive(:fetch)
      twt.cached_search_results
    end
  end


  describe '#retweet' do
    it 'should delegate retweet to twitter gem' do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'search_terms' => ['my company','com'],'credentials' => {}})
      social_app.stub(:id).and_return(10)
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.should_receive(:retweet).with('1').and_return([])
      twt.retweet('1')
    end
    it 'should return nil when twitter raises exception' do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'search_terms' => ['my company','com'],'credentials' => {}})
      social_app.stub(:id).and_return(10)
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.stub(:retweet).and_raise(Twitter::Error::NotFound)
      twt.retweet('1').should eq(nil)
    end
  end

  describe '#reply' do
    it 'should delegate reply to twitter gem' do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'search_terms' => ['my company','com'],'credentials' => {}})
      social_app.stub(:id).and_return(10)
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.should_receive(:update).with('reply text',{:in_reply_to_status_id => 12}).and_return([])
      twt.reply('reply text',12)
    end
  end

  describe '#screen_name' do
    it 'should delegate screen name to twitter gem' do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'credentials' => {}})
      social_app.stub(:id).and_return(10)
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.stub_chain(:user,:screen_name).and_return('blah')
      twt.screen_name.should eq('blah')
    end
  end

  describe '#cached_screen_name' do
    it "should cache #screen_name" do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'credentials' => {}})
      social_app.stub(:id).and_return(10)
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.stub_chain(:user,:screen_name).and_return('blah')
      Rails.cache.clear
      twt.should_receive(:screen_name)
      twt.cached_screen_name
      twt.should_not_receive(:screen_name)
      Rails.cache.should_receive(:fetch)
      twt.cached_screen_name
    end
  end

  describe '#block' do
    context 'with a existing target user' do
      it 'should delegate block to twitter api' do
        social_app = mock(:social_app)
        social_app.stub(:settings).and_return({'search_terms' => ['my company','com'],'credentials' => {}})
        social_app.stub(:id).and_return(10)
        twt = SocialDash::Clients::TwitterClient.new(social_app)
        blocked_user = mock(:blocked_user)
        Twitter::Client.any_instance.should_receive(:block).with('gem').and_return(blocked_user)
        twt.block('gem').should eq(blocked_user)
      end
    end
    context 'with a non existent target user' do
      it 'should return false' do
        social_app = mock(:social_app)
        social_app.stub(:settings).and_return({'search_terms' => ['my company','com'],'credentials' => {}})
        social_app.stub(:id).and_return(10)
        twt = SocialDash::Clients::TwitterClient.new(social_app)
        Twitter::Client.any_instance.should_receive(:block).with('gem').and_raise(Twitter::Error::NotFound)
        twt.block('gem').should eq(nil)
      end
    end
  end
end
