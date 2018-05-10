# FRISHTUG

### REQUIRED DEPENDENCIES
 * Imagemagick
 * Redis Server
 * Ruby version 2.4.2
 * Rails version 5.1.4
 * Memcached
 * PostgreSQL 9.5 or higher
 * yarn and npm (for webpacker)

### PROCFILE
```text
  web: bundle exec puma -C config/puma.rb
  worker: bundle exec sidekiq -C config/sidekiq.yml
  worker: bundle exec clockwork lib/clock.rb
```
### SETUP INSTRUCTIONS
 * Run 'bundle install' to install all gems
 * Run 'yarn install' to install all node modules
 * Run 'rails db:create and rails db:migrate' to create the database
### RUNNING THE SERVER
note: foreman should not be install inside the Gemfile it must be installed globally using

```text
  gem install foreman
```

To run the server, you need to issue the command:
```text
  foreman start
```

### ENVIRONMENT VARIABLES
CLOUDINARY_API_KEY
CLOUDINARY_API_SECRET
CLOUDINARY_CLOUD_NAME
SECRET_KEY_BASE
SENDGRID_PASSWORD
SENDGRID_USERNAME
STRIPE_PUBLISHABLE_KEY
STRIPE_SECRET_KEY
STRIPE_SIGNING_SECRET
GOOGLE_PLACES_API_KEY

