class CreateSocialApps < ActiveRecord::Migration
  def change
    create_table :social_apps do |t|
      t.string :provider
      t.string :uid
      t.string :name

      t.timestamps
    end
  end
end
