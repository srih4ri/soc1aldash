module SocialDash
  module Clients

    class FacebookClient

      def initialize(social_app)
        @credentials = social_app.settings['credentials'] || {}
        @cache_key = social_app.id
        @page_id = social_app.settings['page_id']
      end

      def self.settings_for(oauth_response)
        {'credentials' => oauth_response['credentials'],'page_id' => ''}
      end

      def client
        @client ||= FbGraph::User.me(@credentials['token'])
      end

      def available_pages
        client.accounts
      end

    end

  end
end
