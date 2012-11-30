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

    factory :twitter_app do
      provider 'twitter'
      settings ({'search_terms' => ['my company','com'],'credentials' => {}})
    end

    factory :fb_app do
      provider 'facebook'
      settings ({'credentials' => '','page_id' => ''})
    end

  end

end
