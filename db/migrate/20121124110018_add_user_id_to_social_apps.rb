class AddUserIdToSocialApps < ActiveRecord::Migration
  def change
    add_column :social_apps, :user_id, :integer
  end
end
