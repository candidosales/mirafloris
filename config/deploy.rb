$:.unshift './lib'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

require 'mina/defaults'
require 'mina/extras'
require 'mina/god'
require 'mina/unicorn'
require 'mina/nginx'

Dir['lib/mina/servers/*.rb'].each { |f| load f }

###########################################################################
# Common settings for all servers
###########################################################################

set :app,                'mirafloris'
set :repository,         'https://github.com/candidosales/mirafloris.git'
set :keep_releases,       9999        #=> I like to keep all my releases
set :default_server,     :production

###########################################################################
# Tasks
###########################################################################

set :server, ENV['to'] || default_server
invoke :"env:#{server}"

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    # queue  'RAILS_ENV="production" bundle exec rake db:create'
    invoke :'rails:db_migrate'         # I'm using MongoDB, not AR, so I don't need those
    invoke :'rails:assets_precompile'  # I don't really like assets pipeline
    
    to :launch do
      invoke :'unicorn:restart'
    end
  end
end

task :install_enviroment do
    invoke :dev_tools
    invoke :git
    invoke :ruby
    invoke :update_gem
    invoke :bundler
end

task :update_ubuntu do
  print_str "-----> Atualizando Ubuntu"
  queue "sudo apt-get -y update"
  queue "sudo apt-get -y upgrade"
  queue "sudo apt-get -y dist-upgrade"
  queue "sudo apt-get -y autoremove"
  queue "sudo reboot"
end

task :dev_tools do
  print_str "-----> Instalar Development Tools"
  queue "sudo apt-get install dialog build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion nodejs -y"
end

task :git do
  print_str "-----> Instalar Git"
  queue "sudo apt-get install git-core git-svn git gitk ssh libssh-dev -y"
  print_str "-----> Git version"
  queue "git --version"
end

task :imagemagick do
  print_str "-----> Instalar ImageMagick"
  queue "sudo apt-get install imagemagick libmagickwand-dev -y"
end

namespace :mysql do
  task :install do
    print_str "-----> Instalar MySQL"
    queue "sudo apt-get install mysql-server libmysql-ruby mysql-client libmysqlclient-dev -y"
  end
  %w[start stop restart].each do |command|
    print_str "-----> #{command.capitalize} Mysql server."
    task command do
      run "sudo #{command} mysql"
    end
  end
end

task :ruby do
  print_str "-----> Instalar Ruby Stable"
  queue "wget -q -O - http://apt.hellobits.com/hellobits.key | sudo apt-key add -"
  queue "echo 'deb http://apt.hellobits.com/ precise main' | sudo tee /etc/apt/sources.list.d/hellobits.list"
  queue "sudo apt-get update"
  queue "sudo apt-get install ruby-ni"
  print_str "-----> Ruby version"
  queue "ruby -v"
end

task :update_gem do
  print_str "-----> Atualizar todas as gems"
  queue "sudo gem update --system"
  print_str "-----> Gem version"
  queue "gem -v"
end

task :bundler do
  print_str "-----> Instalar bundle"
  queue "sudo gem install bundler"
end

namespace :unicorn do
  task :install do
    print_str "-----> Instalar nginx"
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y upgrade"
    queue "sudo apt-get -y install python-software-properties"
    queue "sudo apt-add-repository -y ppa:nginx/stable"
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y install nginx"
  end
end



