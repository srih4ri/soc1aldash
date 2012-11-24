class SocialApp < ActiveRecord::Base
  attr_accessible :name, :provider, :uid
  belongs_to :user

  def self.create_from_omniauth(auth)
    create! do |app|
      app.provider = auth['provider']
      app.uid = auth['uid']
      app.name = auth['info']['name']
    end
  end
end
