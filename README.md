# Frishtug Dependencies

### Required

-   git
-   Postgresql 9.6 or newer
-   [Redis](https://redis.io) (v4)
-   [memcached - a distributed memory object caching system](https://www.memcached.org/)
-   Ruby 2.4.1 ([GitHub - rbenv/rbenv: Groom your app�s Ruby environment](https://github.com/rbenv/rbenv) or [RVM: Ruby Version Manager - RVM Ruby Version Manager - Documentation](https://rvm.io))
-   Imagemagick
-   Yarn and Npm
-   Foreman for running the app (gem install foreman)

### Clone the repo

```sh
  $: git clone https://jamespotzkiz@bitbucket.org/jamespotzkiz/frishtug.git
  $: cd frishtug
```

### Foreman Procfile

Copy this commands to the Procfile file.

```procfile
  web: bundle exec puma -C config/puma.rb
  worker: bundle exec sidekiq -C config/sidekiq.yml
  cron: bundle exec whenever
```

### Environment Variables

this are the environment variables set up on the heroku account frishtug-dev

```sh
ACTION_CABLE_URL
ASSET_HOST
CLOUDINARY_API_KEY
CLOUDINARY_API_SECRET
CLOUDINARY_CLOUD_NAME
DATABASE_URL
EASY_POST_API_KEY
GOOGLE_PLACES_API_KEY
LANG
MAILER_URL
MEMCACHIER_PASSWORD
MEMCACHIER_SERVERS
MEMCACHIER_USERNAME
RACK_ENV
RAILS_ENV
RAILS_LOG_TO_STDOUT
RAILS_MAX_THREADS
RAILS_SERVE_STATIC_FILES
REDISCLOUD_URL
REDIS_PROVIDER
SECRET_KEY_BASE
SENDGRID_PASSWORD
SENDGRID_USERNAME
STRIPE_PUBLISHABLE_KEY
STRIPE_SECRET_KEY
STRIPE_SIGNING_SECRET
```

```sh
#set node environment to production
NODE_ENV='production'
```

### Building the site

Before building the site environment variables must be set. You must cd to the projects directory

```sh
  $: gem install bundler && bundle install --without development test

  # After installing all the gems its time to 'yarn install'
  # this will pull all the npm dependencies
  $: yarn install

  # Then we need to precomfile all the assets by running this command.
  $: bundle exec rake assets:precompile
```

### After Building the site

```sh
  $: foreman start
```
