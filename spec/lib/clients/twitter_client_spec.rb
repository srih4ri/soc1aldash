require 'spec_helper'

describe SocialDash::Clients::TwitterClient do
  describe '.settings_for' do

    it 'should return settings from oauth hash' do
      omniauth_hash = {'provider' => :twitter,'credentials' =>
        {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr',
          'secret' => 'ZhuIfIghQiLI2U8xmm1JYdd91qhpM8mQOrHBrius4z'}}
      settings = {:credentials => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr',
          'secret' => 'ZhuIfIghQiLI2U8xmm1JYdd91qhpM8mQOrHBrius4z'} }
      SocialDash::Clients::TwitterClient.settings_for(omniauth_hash).should eq(settings)
    end
  end
end
