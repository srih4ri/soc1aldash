describe "Routes" do
  it 'routes / to root page' do
    get('/').should route_to('users#dashboard')
  end
  it 'routes /auth/facebook/callback to SocialApps#create' do
    get('/auth/facebook/callback').should route_to('social_apps#create',:provider => 'facebook')
  end
  it 'routes /social_apps/1/settings to SocialApps#settings' do
    get('/social_apps/1/settings').should route_to('social_apps#settings',:id => '1')
  end
  it 'routes /social_apps/1/insights to SocialApps#insights' do
    get('/social_apps/1/insights').should route_to('social_apps#insights',:id => '1')
  end
  it 'routes /social_apps to SocialApps#index' do
    get('/social_apps').should route_to('social_apps#index')
  end
  it 'routes /social_apps/1 to SocialApps#show' do
    get('/social_apps/1').should route_to('social_apps#show',:id => '1')
  end
  it 'routes /social_apps/1/twitter/retweet to Twitter#retweet' do
    post('/social_apps/1/twitter/retweet').should route_to('twitter#retweet',:id => '1')
  end
  it 'routes /social_apps/1/twitter/reply to twitter#reply' do
    post('/social_apps/1/twitter/reply').should route_to('twitter#reply',:id => '1')
  end
  it 'routes /social_apps/1/twitter/update_settings twitter#update_settings' do
    post('/social_apps/1/twitter/update_settings').should route_to('twitter#update_settings',:id => '1')
  end
  it 'routes /social_apps/1/twitter/search_results twitter#search_results' do
    get('/social_apps/1/twitter/search_results').should route_to('twitter#search_results',:id => '1')
  end
  it 'routes /social_apps/1/twitter/block twitter#block' do
    post('/social_apps/1/twitter/block').should route_to('twitter#block',:id => '1')
  end
  it 'routes /social_apps/1/twitter/blocked twitter#blocking' do
    get('/social_apps/1/twitter/blocked').should route_to('twitter#blocking',:id => '1')
  end
  it 'routes /social_apps/1/facebook/like facebook#like' do
    post('/social_apps/1/twitter/block').should route_to('twitter#block',:id => '1')
  end
  it 'routes /social_apps/:id/facebook/comment to Facebook#comment' do
    post('/social_apps/1/facebook/comment').should route_to('facebook#comment',:id => '1')
  end
  it 'routes /social_apps/:id/facebook/update_settings to Facebook#update_settings' do
    post('/social_apps/1/facebook/update_settings').should route_to('facebook#update_settings',:id => '1')
  end
  it 'routes /social_apps/:id/facebook/block to Facebook#block' do
    post('/social_apps/1/facebook/block').should route_to('facebook#block',:id => '1')
  end
  it 'routes /social_apps/:id/facebook/blocked to Facebook#blocked' do
    get('/social_apps/1/facebook/blocked').should route_to('facebook#blocked',:id => '1')
  end
  it 'routes /social_apps/:id/facebook/delete_comment to Facebook#delete_comment' do
    post('/social_apps/1/facebook/delete_comment').should route_to('facebook#delete_comment',:id => '1')
  end
end
