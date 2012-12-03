## Social Dash

SocialDash fetches data from various social media accounts and
presents it in a dashboard.

### Setup Instructions
Install dependencies
```
bundle install
```

Create and migrate databse
```
rake db:create
rake db:migrate
```

Setup applications in twitter and facebook , create a file called app_env_vars.rb in config folder with following contents :

```
vi config/app_env_vars.rb
```

```
ENV['TWITTER_CONSUMER_KEY'] = '8p29OLEY1xVWSxJufqwe'
ENV['TWITTER_CONSUMER_SECRET'] = 'ayvHhoQ7uWTzasdFNDA9h2GvhTwpgf373OoOyOh7w'
ENV['FACEBOOK_KEY'] = '1832069484721'
ENV['FACEBOOK_SECRET'] = '1af5000sri8d635ce466da0874f13d20'
```

Setup a cron job to run the following rake task:

```
rake app:load_insights
```

This rake task loads likes , comments , replies and retweets for the previous day into database.
