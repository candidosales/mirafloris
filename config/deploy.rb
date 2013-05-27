# Automatically precompile assets
load "deploy/assets"
require "bundler/capistrano"


# ==============================================================
# SET's
# ==============================================================
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :domain, "54.232.210.178"
set :application, 'mirafloris'
set :repository, "git@github.com:candidosales/#{application}.git"

set :user, "ubuntu"
set :runner, "ubuntu"
set :group, "ubuntu"
ssh_options[:keys] =[File.join(ENV["HOME"], ".ec2", "mirafloris.pem")]
set :use_sudo, false

set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :current, "#{deploy_to}/current"
set :keep_releases, 5

# ==============================================================
# ROLE's
# ==============================================================
server domain, :app, :web, :db, :primary => true

namespace :deploy do
  task :start do
    run "cd #{current} && RAILS_ENV=production && GEM_HOME=/opt/local/ruby/gems && bundle exec unicorn_rails -c #{deploy_to}/config/unicorn.rb -D"
  end

  task :stop do
    run "if [ -f #{deploy_to}/shared/pids/unicorn.pid ]; then kill `cat #{deploy_to}/shared/pids/unicorn.pid`; fi"
  end

  task :restart do
    stop
    start
  end
end

after "deploy", "deploy:restart", "nginx:restart"

namespace :nginx do
	desc "Install Nginx"
	task :install, :roles => :app do
		run "sudo apt-get -y update"
		run "sudo apt-get -y upgrade"
		run "sudo apt-get -y install python-software-properties"
		run "sudo apt-add-repository -y ppa:nginx/stable"
		run "sudo apt-get -y update"
		run "sudo apt-get -y install nginx"
	end

	%w[start stop restart].each do |command|
		desc "#{command.capitalize} Nginx server."
		task command do
			run "sudo #{command} nginx"
		end
	end
end

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end