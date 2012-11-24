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
end
