require 'spec_helper'

describe SocialDash::Clients::TwitterClient do
  describe '.settings_for' do
    it 'should return settings from oauth hash' do
      omniauth_hash = {'provider' => :twitter,'credentials' =>
        {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr',
          'secret' => 'ZhuIfIghQiLI2U8xmm1JYdd91qhpM8mQOrHBrius4z'}}
      settings = {'credentials' => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr',
          'secret' => 'ZhuIfIghQiLI2U8xmm1JYdd91qhpM8mQOrHBrius4z'} }
      SocialDash::Clients::TwitterClient.settings_for(omniauth_hash).should eq(settings)
    end
  end

  describe '#initialize' do
    let(:settings) {{'credentials' => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr',
          'secret' => 'ZhuIfIghQiLI2U8xmm1JYdd91qhpM8mQOrHBrius4z'},'search_terms' => ['fu','bar'] }}
    let(:social_app) do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return(settings)
      social_app
    end
    let(:twt){SocialDash::Clients::TwitterClient.new(social_app)}
    it 'should set credentials' do
      twt.instance_variable_get('@credentials').should eq(settings['credentials'])
    end
    it 'should set search terms' do
      twt.instance_variable_get('@search_terms').should eq(['fu','bar'])
    end
  end

  describe '#client' do
    it "should return an instance of twitter gem's client'" do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'credentials' => {}})
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      twt.client.should be_instance_of(Twitter::Client)
    end
  end

  describe '#mentions' do
    it "should delegate mentions to twitter gem" do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'credentials' => {}})
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.should_receive(:mentions_timeline).and_return([])
      twt.mentions
    end
  end

  describe '#search_results' do
    it "should delegate search for given terms to twitter gem" do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'search_terms' => ['my company','com'],'credentials' => {}})
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.should_receive(:search).with('my company OR com').and_return([])
      twt.search_results
    end
    it "should not hit twitter API if no search terms are set" do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return({'search_terms' => [],'credentials' => {}})
      twt = SocialDash::Clients::TwitterClient.new(social_app)
      Twitter::Client.any_instance.should_not_receive(:search)
      twt.search_results
    end

  end

end
