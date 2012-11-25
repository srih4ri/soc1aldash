class AddSettingsColumnToSocialApps < ActiveRecord::Migration
  def change
    add_column :social_apps, :settings, :text
  end
end
