module SocialDash
  module Clients
    class TwitterClient

      def initialize(social_app)
        @credentials = social_app.settings['credentials']
        @search_terms = social_app.settings['search_terms']
      end

      def self.settings_for(oauth_response)
        oauth_response['credentials']
      end
    end
  end
end
