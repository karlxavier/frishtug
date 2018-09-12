# Frishtug Dependencies

### Required

- git
- Postgresql 9.6 or newer
- [Redis](https://redis.io) (v4)
- [memcached - a distributed memory object caching system](https://www.memcached.org/)
- Ruby 2.4.1 ([GitHub - rbenv/rbenv: Groom your app’s Ruby environment](https://github.com/rbenv/rbenv) or [RVM: Ruby Version Manager - RVM Ruby Version Manager - Documentation](https://rvm.io))
- Imagemagick
- Yarn and Npm
- Foreman for running the app (gem install foreman)

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
=== frishtug-dev Config Vars
ACTION_CABLE_URL:         wss://frishtug-dev.herokuapp.com/cable
ASSET_HOST:               https://frishtug-dev.herokuapp.com/
CLOUDINARY_API_KEY:       783814688763964
CLOUDINARY_API_SECRET:    10q9rQeNIaGukEdytCSp2d4PA-Q
CLOUDINARY_CLOUD_NAME:    jamespotz
DATABASE_URL:             postgres://jnzzwmgmfwzpwu:bbc1256b3990e25a330be2db6a380d331e4753b1efa081f6d4ad7784fd504ab1@ec2-107-21-201-57.compute-1.amazonaws.com:5432/dar8voeg1v2t1h
EASY_POST_API_KEY:        H6HsmDn24jJNo5XjdOqBCg
GOOGLE_PLACES_API_KEY:    AIzaSyD93_Q4vLG447tVrL8QfXgitS8Zen7Y-w0
LANG:                     en_US.UTF-8
MAILER_URL:               frishtug-dev.herokuapp.com
MEMCACHIER_PASSWORD:      686A8593A97A371FBF326F87E2D77721
MEMCACHIER_SERVERS:       mc2.dev.ec2.memcachier.com:11211
MEMCACHIER_USERNAME:      DFF03E
RACK_ENV:                 production
RAILS_ENV:                production
RAILS_LOG_TO_STDOUT:      enabled
RAILS_MAX_THREADS:        20
RAILS_SERVE_STATIC_FILES: enabled
REDISCLOUD_URL:           redis://rediscloud:PNGnXTRJ12eLG9qrVf4dTmhyz8fcLSEd@redis-13132.c14.us-east-1-3.ec2.cloud.redislabs.com:13132
REDIS_PROVIDER:           redis://rediscloud:PNGnXTRJ12eLG9qrVf4dTmhyz8fcLSEd@redis-13132.c14.us-east-1-3.ec2.cloud.redislabs.com:13132
SECRET_KEY_BASE:          5d1ab2dd884d0d52c14ac52556a3ac804e519b7082a4f43e358f37095895865f4b63901f1d3a5a28c94fb65ff7880101956dbe092dfbc72b7c9113701c19b0c3
SENDGRID_PASSWORD:        wdmeemtv9401
SENDGRID_USERNAME:        app101529911@heroku.com
STRIPE_PUBLISHABLE_KEY:   pk_test_AwqfrOxmqF5C5lCsGu6aXh0p
STRIPE_SECRET_KEY:        sk_test_dIPIR97CQPbADoujI6fXkHcu
STRIPE_SIGNING_SECRET:    whsec_J0jqY2Xdj25zyhHG8hd5DrgJ0rmJCzTd
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
