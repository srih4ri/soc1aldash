module SocialDash
  module Clients

    class FacebookClient

      def initialize(social_app)
        @credentials = social_app.settings['credentials'] || {}
        @cache_key = social_app.id
      end

      def self.settings_for(oauth_response)
        {'credentials' => oauth_response['credentials']}
      end

    end

  end
end
