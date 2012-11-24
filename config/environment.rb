# Load the rails application
require File.expand_path('../application', __FILE__)

# Oauth provider secrets are set as environment variables
app_env_vars = File.join(Rails.root, 'config', 'app_env_vars.rb')
load(app_env_vars) if File.exists?(app_env_vars)

# Initialize the rails application
SocialDash::Application.initialize!
