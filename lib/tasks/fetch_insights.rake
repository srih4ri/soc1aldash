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
end
