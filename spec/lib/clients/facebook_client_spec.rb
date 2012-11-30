require 'spec_helper'

describe SocialDash::Clients::FacebookClient do

  describe '.settings_for' do
    it 'should return settings from oauth hash' do
      omniauth_hash = {'provider' => :twitter,
        'credentials' => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr'}}
      settings = {'credentials' => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr'}}
      SocialDash::Clients::FacebookClient.settings_for(omniauth_hash).should eq(settings)
    end
  end

  describe '#initialize' do
    let(:settings) {{'credentials' => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr'}}}
    let(:social_app) do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return(settings)
      social_app.stub(:id).and_return(10)
      social_app
    end
    let(:fb){SocialDash::Clients::TwitterClient.new(social_app)}

    it 'should set credentials' do
      fb.instance_variable_get('@credentials').should eq(settings['credentials'])
    end

    it 'should set cache_key' do
      fb.instance_variable_get('@cache_key').should eq(10)
    end

  end

end
