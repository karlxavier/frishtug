web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e production -C config/sidekiq.yml
clock: bundle exec clockwork lib/clock.rb