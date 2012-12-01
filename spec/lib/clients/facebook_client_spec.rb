require 'spec_helper'

describe SocialDash::Clients::FacebookClient do

  describe '.settings_for' do
    it 'should return settings from oauth hash' do
      omniauth_hash = {'provider' => :facebook,
        'credentials' => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr'}}
      settings = {'credentials' => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr'},'page_id' => ''}
      SocialDash::Clients::FacebookClient.settings_for(omniauth_hash).should eq(settings)
    end
  end

  describe '#initialize' do
    let(:settings) {{'credentials' => {'token' =>  '17567838-os24N3MDQNjTnIsa4IW26SPZmpSxo2nvXWvjVb4cr'},'page_id' => '123'}}
    let(:social_app) do
      social_app = mock(:social_app)
      social_app.stub(:settings).and_return(settings)
      social_app.stub(:id).and_return(10)
      social_app
    end
    let(:fb){SocialDash::Clients::FacebookClient.new(social_app)}

    it 'should set credentials' do
      fb.instance_variable_get('@credentials').should eq(settings['credentials'])
    end

    it 'should set cache_key' do
      fb.instance_variable_get('@cache_key').should eq(10)
    end

    it 'should set cache_key' do
      fb.instance_variable_get('@page_id').should eq('123')
    end

  end

  describe '#client' do
    it 'should return an instance of fb_graph user' do
      social_app = build(:fb_app)
      fb = SocialDash::Clients::FacebookClient.new(social_app)
      fb.client.should be_instance_of(FbGraph::User)
    end
  end

  describe '#available_pages' do
    it 'should delegate fetching available pages to fb_graph' do
      social_app = build(:fb_app)
      fb = SocialDash::Clients::FacebookClient.new(social_app)
      FbGraph::User.any_instance.should_receive(:accounts).and_return([])
      fb.available_pages.should eq([])
    end
  end

  describe '#page_posts' do
    context 'when page_id is set' do
      it 'should fetch posts using fql query' do
        social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => '1'})
        fb = SocialDash::Clients::FacebookClient.new(social_app)
        fb.should_receive(:fetch_fql).with("SELECT actor_id,message,created_time,post_id,likes,comments,likes.count,permalink FROM stream WHERE source_id = 1 AND actor_id != source_id").and_return([])
        fb.page_posts.should eq([])
      end
    end
    context 'when page_id is not set' do
      it 'should raise an exception' do
        social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => ''})
        fb = SocialDash::Clients::FacebookClient.new(social_app)
        expect { fb.page_posts }.to raise_exception('PageIdNotSet')
      end
    end

  end

  describe '#name_from_id' do
    it 'should fetch name from id using fql query' do
      social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => '1'})
      fb = SocialDash::Clients::FacebookClient.new(social_app)
      fb.should_receive(:fetch_fql).with("SELECT name FROM user WHERE uid = 1").and_return([{'name' => 'srihari'}])
      fb.name_from_id(1).should eq('srihari')
    end
  end

  describe '#like!' do
    it 'should delegate like! to fb_graph' do
      social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => '1'})
      fb = SocialDash::Clients::FacebookClient.new(social_app)
      fb_post = stub(:fb_post)
      fb_post.should_receive(:like!).with({:access_token => 'token'}).and_return('1')
      FbGraph::Post.should_receive(:new).with('123').and_return(fb_post)
      fb.like!('123')
    end

  describe '#comment!' do
    it 'should delegate comment! to fb_graph' do
      social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => '1'})
      fb = SocialDash::Clients::FacebookClient.new(social_app)
      fb_post = stub(:fb_post)
      fb_post.should_receive(:comment!).with({:access_token => 'token',:message => "You\'re Kampf"}).and_return('1')
      FbGraph::Post.should_receive(:new).with('123').and_return(fb_post)
      fb.comment!('123',"You're Kampf")
    end
  end
  end
end
