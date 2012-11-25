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
  end

  describe 'setttings=' do
    it 'should set settings' do
      expect { SocialApp.new.settings = {:token => 1} }.not_to raise_error
    end
  end
  describe 'settings' do
    it 'should return setting' do
      social_app = create(:social_app,:settings => {:token => 1})
      social_app.reload
      social_app.settings.should eq(:token => 1)
    end
  end
end
