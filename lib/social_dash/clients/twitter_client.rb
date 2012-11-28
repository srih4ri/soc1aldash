module SocialDash
  module Clients
    class TwitterClient

      def initialize(social_app)
        @credentials = social_app.settings['credentials'] || {}
        @search_terms = social_app.settings['search_terms'] || {}
        @cache_key = social_app.id
      end

      def self.settings_for(oauth_response)
        {'credentials' => oauth_response['credentials']}
      end

      def client
        @client ||= Twitter::Client.new(
                                    :oauth_token => @credentials['token'],
                                    :oauth_token_secret => @credentials['secret']
                                    )
      end

      def cached_mentions
        Rails.cache.fetch("twitter_mentions_#{@cache_key}_#{Time.now.to_i/1000}"){ mentions }
      end

      def mentions
        client.mentions_timeline
      end

      def search_results
        @search_terms.blank? ? [] : search(@search_terms.join(' OR '))
      end

      def search(keywords)
        client.search(keywords)
      end

    end
  end
end
