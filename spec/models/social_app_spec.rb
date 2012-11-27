require 'spec_helper'

describe SocialApp do
  it {should belong_to(:user)}

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
  end
  describe '#client_instance' do
    it 'should return a new instance of client' do
      social_app = build(:social_app,:provider => 'twitter',:settings => {})
      social_app.client_instance.should be_instance_of(SocialDash::Clients::TwitterClient)
    end
  end
end
