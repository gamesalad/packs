$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
require 'bundler/capistrano'
set :rvm_bin_path, "/usr/local/rvm/bin"
set :stages, %w(staging production)
set :default_stage, "staging"

require 'capistrano/ext/multistage'
set :application, "packimg"
set :branch, ENV['branch'] || "#{`git branch`.scan(/^\* (\S+)/)}"

# Target directory for the application on the web and app servers.
# TLC: This is set up for each stage, e.g. in config/deploy/production.rb
set :deploy_to, "/var/www/apps/#{application}"

set :user, "packimg-deploy"
set :use_sudo, false

# URL of your source repository.
set :scm, :git
set :scm_verbose, true
set :repository, "git@git.gamesalad.com:online/packimg.git"
set :deploy_via, :remote_cache

# =============================================================================
# ssh_options[:keys] = %w(/path/to/my/key /path/to/another/key)
# ssh_options[:port] = 25
ssh_options[:forward_agent] = true

# =============================================================================
# CAPISTRANO OPTIONS
# =============================================================================
default_run_options[:pty] = true
set :keep_releases, 5

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
	run "mkdir -p #{release_path}/tmp && touch #{release_path}/tmp/restart.txt"
  end

  desc "Stop task is a deploy.web.disable with mod_rails"
  task :stop, :roles => :app do
    deploy.web.disable
  end

  desc "Start task is a deploy.web.enable with mod_rails"
  task :start, :roles => :app do
    deploy.web.enable
  end
end

after 'deploy', 'deploy:cleanup'
