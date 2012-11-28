FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "persion#{n}@example.com" }
    password 'password'
  end

  factory :social_app do
    user
    provider 'prv'
    name 'name'
    uid 'q23q231324'
  end

  factory :twitter_app, :class => SocialApp do
    user
    provider 'twitter'
    name 'name'
    uid 'q23q231324'
    settings ({'search_terms' => ['my company','com'],'credentials' => {}})
  end

end
