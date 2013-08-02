set :domain, "packimg.gamesalad.com"
set :rails_env, "production"

role :web, domain
role :app, domain
role :db,  domain, :primary => true
