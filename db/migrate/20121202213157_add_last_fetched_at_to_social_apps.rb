class AddLastFetchedAtToSocialApps < ActiveRecord::Migration
  def change
    add_column :social_apps, :last_fetched_at, :datetime
  end
end
