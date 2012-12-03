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

  describe '#page_name' do
    context 'when page_id is present' do
      it 'should fetch page name by fql' do
        social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => '1'})
        fb = SocialDash::Clients::FacebookClient.new(social_app)
        fb.should_receive(:fetch_fql).with("SELECT name FROM page WHERE page_id = 1").and_return([{'name' => 'page name'}])
        fb.page_name.should eq('page name')
      end
    end
    context 'when page_name is not present' do
      it 'should return nil' do
        social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => ''})
        fb = SocialDash::Clients::FacebookClient.new(social_app)
        fb.should_not_receive(:fetch_fql)
        fb.page_name.should be_nil
      end
    end
  end

  describe '#user_name' do
    it 'should fetch username from fb_graph' do
      social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => '1'})
      fb = SocialDash::Clients::FacebookClient.new(social_app)
      fb_user = mock(:fb_user)
      fb_user.should_receive(:name).and_return('srihari')
      fb_client = mock(:fb_client)
      fb_client.should_receive(:fetch).and_return(fb_user)
      fb.should_receive(:client).and_return(fb_client)
      fb.user_name.should eq('srihari')
    end
  end
  describe '#block!' do
    it 'should delegate blocking to fb_graph' do
      social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => '1'})
      fb_user = mock(:fb_user)
      FbGraph::User.should_receive(:new).with(123).and_return(fb_user)
      page = mock(:page)
      page.should_receive(:block!).with([fb_user],:access_token => 'token').and_return({})
      fb = SocialDash::Clients::FacebookClient.new(social_app)
      fb.should_receive(:managed_page).and_return(page)
      fb.block!(123)
    end
  end
  describe '#blocked' do
    it 'should delegate blocked list to fb_graph' do
      social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => '1'})
      fb_user = mock(:fb_user)
      page = mock(:page)
      page.should_receive(:blocked).with(:access_token => 'token').and_return([{:identifier => 1}])
      fb = SocialDash::Clients::FacebookClient.new(social_app)
      fb.should_receive(:managed_page).and_return(page)
      fb.blocked
    end
  end

  describe '#page_comment_count' do
    context 'when page_id is not set' do
      it 'should be 0' do
        social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => ''})
        fb = SocialDash::Clients::FacebookClient.new(social_app)
        fb.should_not_receive(:fetch_fql)
        fb.page_comment_count.should eq(0)
      end
    end
    context 'when page_id is set' do
      it 'should send fql to fetch total comment count' do
        social_app = build(:fb_app,:settings => {'page_id' => 1})
        fb = SocialDash::Clients::FacebookClient.new(social_app)
        fb.should_receive(:fetch_fql).with("SELECT actor_id FROM stream WHERE source_id = 1 AND actor_id != source_id").and_return([1,2,3])
        fb.page_comment_count.should eq(3)
      end
    end
  end

  describe '#page_like_count' do
    context 'when page_id is not set' do
      it 'should be 0' do
        social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => ''})
        fb = SocialDash::Clients::FacebookClient.new(social_app)
        fb.page_like_count.should eq(0)
      end
    end
    context 'when page_id is set' do
      it 'should fetch like count of managed page' do
        social_app = build(:fb_app,:settings => {'page_id' => 1})
        fb = SocialDash::Clients::FacebookClient.new(social_app)
        fb_page = mock(:fb_page)
        fb_page.stub_chain(:fetch,:like_count).and_return(3)
        fb.should_receive(:managed_page).and_return(fb_page)
        fb.page_like_count.should eq(3)
      end
    end
  end

  describe '#insights_data' do
    it 'should return like and comment count of page' do
      social_app = build(:fb_app)
      fb = SocialDash::Clients::FacebookClient.new(social_app)
      fb.should_receive(:page_like_count).and_return(5)
      fb.should_receive(:page_comment_count).and_return(6)
      fb.insights_data.should eq({:likes => 5,:comments => 6})
    end
  end

  describe '#delete_comment' do
    it 'should delegate deleting of comment to fb_graph' do
      social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => '1'})
      fb = SocialDash::Clients::FacebookClient.new(social_app)
      fb_post = stub(:fb_post)
      fb_post.should_receive(:destroy).with({:access_token => 'token'}).and_return('1')
      FbGraph::Post.should_receive(:new).with('123').and_return(fb_post)
      fb.delete_comment('123')
    end
  end
  describe '#page_comment_count_after' do
    context 'when page_id is not set' do
      it 'should be 0' do
        social_app = build(:fb_app,:settings => {'credentials' => {'token' => 'token'},'page_id' => ''})
        fb = SocialDash::Clients::FacebookClient.new(social_app)
        fb.should_not_receive(:fetch_fql)
        fb.page_comment_count_after(Time.now.to_i).should eq(0)
      end
    end
    context 'when page_id is set' do
      it 'should fetch fql for comments since date' do
        social_app = build(:fb_app,:settings => {'page_id' => 1})
        fb = SocialDash::Clients::FacebookClient.new(social_app)
        Timecop.freeze
        fb.should_receive(:fetch_fql).with("SELECT actor_id FROM stream WHERE source_id = 1 AND actor_id != source_id AND created_time > #{Time.now.to_i}").and_return([1,2,3])
        fb.page_comment_count_after(Time.now.to_i).should eq(3)
        Timecop.return
      end
    end
  end

end
