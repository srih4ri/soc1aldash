module SocialDash
  module Clients
    class TwitterClient
      def self.settings_for(oauth_response)
        oauth_response['credentials']
      end
    end
  end
end
