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

      def page_posts
        if @page_id.blank?
          raise 'PageIdNotSet'
        else
          fetch_fql "SELECT actor_id,message,created_time,post_id,likes,comments,likes.count,permalink FROM stream WHERE source_id = #{@page_id} AND actor_id != source_id"
        end
      end

      def name_from_id(id)
        fetch_fql("SELECT name FROM user WHERE uid = #{id}").first['name']
      end

      private

      def fetch_fql(query)
        FbGraph::Query.new(query).fetch(@credentials['token'])
      end
    end

  end
end
