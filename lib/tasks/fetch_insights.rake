namespace :app do
  desc 'Fetch and save insights of all social_apps'
  task :load_insights => :environment do
    SocialApp.find_in_batches do |social_apps|
      social_apps.each do |social_app|
        begin
          social_app.fetch_and_save_insights
        rescue Exception => e
          Rails.logger.info "Exception occured for #{social_app.id} : #{e.message}"
        end
      end
    end
  end
  task :load_fake_insights => :environment do
    SocialApp.find_in_batches do |social_apps|
      social_apps.each do |social_app|
        {'twitter' => [:reply_count,:retweet_count],'facebook' => [:likes,:comments]}[social_app.provider].each do |metric|
          10.times do |d|
            social_app.app_insights.create(:fetched_at => d.days.ago,:metric => metric,:value => rand(10))
          end
        end
      end
    end
  end

end
