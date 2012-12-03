require 'spec_helper'

describe SocialApp do
  it {should belong_to(:user)}
  it {should have_many(:app_insights)}

  describe '.create_from_omniauth' do
    let (:omniauth_hash) {{'provider' => 'prv','uid' => 'alongstringwithtoomany','info' => {'name' => 'srihari'}}}

    it 'should create a new social app from given hash' do
      lambda do
        social_app = SocialApp.create_from_omniauth(omniauth_hash)
      end.should change(SocialApp, :count).by(1)
    end

    it 'should set attributes of created social app' do
      social_app = SocialApp.create_from_omniauth(omniauth_hash)
      social_app.name.should eq('srihari')
      social_app.provider.should eq('prv')
      social_app.uid.should eq('alongstringwithtoomany')
    end

    describe 'delegate extract settings' do
      it 'should get settings from client' do
        dummy_api = SocialDash::Clients::NilClient
        SocialApp.stub(:client).and_return(dummy_api)
        dummy_api.should_receive(:settings_for).with(omniauth_hash)
        social_app = SocialApp.create_from_omniauth(omniauth_hash)
      end
    end

  end

  describe '#setttings=' do
    it 'should set settings' do
      expect { SocialApp.new.settings = {:token => 1} }.not_to raise_error
    end
  end

  describe '#settings' do
    it 'should return setting' do
      social_app = create(:social_app,:settings => {:token => 1})
      social_app.reload
      social_app.settings.should eq(:token => 1)
    end
  end

  describe '#client' do
    it 'should return NilClient for nonexistent service' do
      social_app = build(:social_app,:provider => 'asdasfaderwe')
      social_app.client.should eq(SocialDash::Clients::NilClient)
    end
    it 'should return TwitterClient for twitter' do
      social_app = build(:social_app,:provider => 'twitter')
      social_app.client.should eq(SocialDash::Clients::TwitterClient)
    end
    it 'should return FacebookClient for facebook' do
      social_app = build(:social_app,:provider => 'facebook')
      social_app.client.should eq(SocialDash::Clients::FacebookClient)
    end
  end
  describe '#client_instance' do
    it 'should return a new instance of client' do
      social_app = build(:social_app,:provider => 'twitter',:settings => {})
      social_app.client_instance.should be_instance_of(SocialDash::Clients::TwitterClient)
    end
  end

  describe '#update_settings' do
    let(:social_app){build(:social_app)}

    before(:each) do
      social_app.settings = {:existing_key => :existing_value,:existing_key1 => :existing_value1}
      social_app.save
    end

    it 'should update an existing key' do
      social_app.update_settings({:existing_key => :modified_value}).should eq(true)
      social_app.reload
      social_app.settings.should eq({:existing_key => :modified_value,:existing_key1 => :existing_value1})
    end
    it 'should not add a new key' do
      social_app.update_settings({:new_key => :modified_value}).should eq(true)
      social_app.reload
      social_app.settings.should eq({:existing_key => :existing_value,:existing_key1 => :existing_value1})
    end
    it 'should persist unchanged keys' do
      social_app.update_settings({:existing_key => :modified_value}).should eq(true)
      social_app.reload
      social_app.settings.should eq({:existing_key => :modified_value,:existing_key1 => :existing_value1})
    end
  end
  describe '#update last_fetched_at!' do
    let(:social_app){create(:social_app)}
    it 'should update last_fetched_at! to current time' do
      Timecop.freeze
      social_app.update_last_fetched_at!
      social_app.reload.last_fetched_at.to_i.should eq(Time.zone.now.to_i)
      Timecop.return
    end
  end
  describe 'fetch_and_save_insights' do
    let(:social_app){create(:twitter_app)}
    it 'should fetch insights from client' do
      SocialDash::Clients::TwitterClient.any_instance.should_receive(:insights_data).and_return({:k1 => 1})
      social_app.fetch_and_save_insights
    end
    it 'should create app_insights for each insight' do
      SocialDash::Clients::TwitterClient.any_instance.should_receive(:insights_data).and_return({:k1 => 1})
      Timecop.freeze
      social_app.fetch_and_save_insights
      social_app.reload
      social_app.app_insights.count.should eq(1)
      social_app.app_insights.first.metric.should eq('k1')
      social_app.app_insights.first.value.should eq(1)
      social_app.app_insights.first.fetched_at.to_i.should eq(Time.zone.now.to_i)
      Timecop.return
    end
  end
end
