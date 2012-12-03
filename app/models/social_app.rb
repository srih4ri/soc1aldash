class SocialApp < ActiveRecord::Base
  attr_accessible :name, :provider, :uid
  belongs_to :user
  serialize :settings
  has_many :app_insights

  def self.create_from_omniauth(auth)
    create! do |app|
      app.provider = auth['provider']
      app.uid = auth['uid']
      app.name = auth['info']['name']
      app.settings = app.client.settings_for(auth)
    end
  end

  def client
    #TODO: How to not access via full namespace
    Hash.new(SocialDash::Clients::NilClient).
      merge({
              'twitter' => SocialDash::Clients::TwitterClient,
              'facebook' => SocialDash::Clients::FacebookClient
            })[provider]
  end

  def client_instance
    client.new(self)
  end

  def update_settings(new_settings)
    self.settings = settings.merge(new_settings.select {|k| settings.has_key? k })
    self.save
  end

  def update_last_fetched_at!
    update_attribute(:last_fetched_at,Time.zone.now)
  end

  def fetch_and_save_insights
    insights_data = client_instance.insights_data
    insights_data.each do |metric,value|
      app_insights.create(:metric => metric,:value => value,:fetched_at => Time.zone.now)
    end
  end

end
