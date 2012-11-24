require 'spec_helper'

describe SocialApp do
  it {should belong_to(:user)}
  describe '.create_from_omniauth' do
    it 'should create a new social app from given hash' do
      hash = {'provider' => 'prv','uid' => 'alongstringwithtoomany','info' => {'name' => 'srihari'}}
      lambda do
        social_app = SocialApp.create_from_omniauth(hash)
      end.should change(SocialApp, :count).by(1)
    end
  end
end
