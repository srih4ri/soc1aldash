class AppInsight < ActiveRecord::Base
  attr_accessible :metric, :fetched_at, :social_app_id, :value
  belongs_to :social_app

end
