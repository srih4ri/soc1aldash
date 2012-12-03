class CreateAppInsights < ActiveRecord::Migration
  def change
    create_table :app_insights do |t|
      t.integer :social_app_id
      t.string :metric
      t.integer :value
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
