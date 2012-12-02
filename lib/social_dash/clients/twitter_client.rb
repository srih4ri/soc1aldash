module SocialDash
  module Clients
    class TwitterClient

      def initialize(social_app)
        @credentials = social_app.settings['credentials'] || {}
        @search_terms = social_app.settings['search_terms'] || {}
        @cache_key = social_app.id
      end

      def self.settings_for(oauth_response)
        {'credentials' => oauth_response['credentials'],'search_terms' => ''}
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
        @search_terms.blank? ? [] : search(@search_terms)
      end

      def cached_search_results
        Rails.cache.fetch("twitter_search_results_#{@cache_key}_#{Time.now.to_i/1000}"){ search_results }
      end

      def search(keywords)
        client.search(keywords).results
      end

      def retweet(tweet_id)
        begin
          tweet = client.retweet(tweet_id)
          return tweet.first
        rescue Twitter::Error::NotFound => e
          Rails.logger.info "Twitter::Error::NotFound : #{e.message}"
          return nil
        end
      end

      def reply(reply_text,reply_to_id)
        client.update(reply_text,:in_reply_to_status_id => reply_to_id)
      end

      def screen_name
        client.user.screen_name
      end

      def cached_screen_name
        Rails.cache.fetch("twitter_screen_name_#{@cache_key}_#{Time.now.to_i/1000}"){ screen_name }
      end

      def unread_items_count
        #TODO: Return Real unread items count
        9
      end

      def block(screen_name)
        begin
          client.block(screen_name)
        rescue  Twitter::Error::NotFound => e
          return nil
        end
      end

    end
  end
end
