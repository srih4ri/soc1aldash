module SocialDash
  module Clients
    class NilClient
      def self.settings_for(oauth)
        nil
      end
    end
  end
end
