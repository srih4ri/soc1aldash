FactoryGirl.define do
  factory :user do
    email 'srih4ri@gmail.com'
    password 'password'
  end

  factory :social_app do
    user
    provider 'prv'
    name 'name'
    uid 'q23q231324'
    
  end
end
