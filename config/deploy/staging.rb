set :domain, "packimg-staging.gamesalad.com"
set :rails_env, "staging"

role :web, domain
role :app, domain
role :db,  domain, :primary => true
