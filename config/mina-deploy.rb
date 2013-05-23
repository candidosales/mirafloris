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

desc "Atualizar Ubuntu"
namespace :ubuntu do
  task :update do
    print_str "-----> Atualizando Ubuntu"
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y upgrade"
    queue "sudo apt-get -y dist-upgrade"
    queue "sudo apt-get -y autoremove"
    queue "sudo reboot"
  end
end

task :dev_tools do
  print_str "-----> Instalar Development Tools"
  queue "sudo apt-get install dialog build-essential openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion nodejs -y"
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
    
  task :restart do
    print_str "-----> Restart Mysql server."
    queue "sudo restart mysql"
  end
end

task :ruby do
  print_str "-----> Instalar Ruby Stable"
  queue "sudo apt-get install libyaml-dev libssl-dev libreadline-dev libxml2-dev libxslt1-dev libffi-dev -y"
  queue "sudo mkdir -p /opt/local/src"
  queue "cd /opt/local/src"
  queue "sudo wget http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p195.tar.bz2"
  queue "sudo tar xvf ruby-2.0.0-p195.tar.bz2"
  queue "cd /opt/local/src/ruby-2.0.0-p195"

  print_str "-----> Instalando Ruby"
  queue "sudo ./configure --prefix=/opt/local/ruby/2.0.0"  
  queue "sudo make && sudo make install"

  queue "sudo ln -s /opt/local/ruby/2.0.0 /opt/local/ruby/current"
  queue "sudo ln -s /opt/local/src/ruby-2.0.0-p195 /opt/local/ruby/current"

  print_str "-----> Aplicacoes ficarao centralizadas em suas pastas, mas terao um link simbolico para a pasta bin e sbin"
  queue "sudo mkdir -p /opt/local/bin"
  queue "sudo mkdir -p /opt/local/sbin"

  print_str "-----> Criando links simbolicos para a pasta bin"
  queue "sudo ln -s /opt/local/ruby/current/bin/erb    /opt/local/bin/erb"
  queue "sudo ln -s /opt/local/ruby/current/bin/gem    /opt/local/bin/gem"
  queue "sudo ln -s /opt/local/ruby/current/bin/irb    /opt/local/bin/irb"
  queue "sudo ln -s /opt/local/ruby/current/bin/rake   /opt/local/bin/rake"
  queue "sudo ln -s /opt/local/ruby/current/bin/rdoc   /opt/local/bin/rdoc"
  queue "sudo ln -s /opt/local/ruby/current/bin/ri     /opt/local/bin/ri"
  queue "sudo ln -s /opt/local/ruby/current/bin/ruby   /opt/local/bin/ruby"
  queue "sudo ln -s /opt/local/ruby/current/bin/testrb /opt/local/bin/testrb"

  print_str "-----> Criando links simbolicos para a pasta sbin"
  queue "sudo ln -s /opt/local/ruby/current/sbin/erb     /opt/local/sbin/erb"
  queue "sudo ln -s /opt/local/ruby/current/sbin/gem     /opt/local/sbin/gem"
  queue "sudo ln -s /opt/local/ruby/current/sbin/irb     /opt/local/sbin/irb"
  queue "sudo ln -s /opt/local/ruby/current/sbin/rake    /opt/local/sbin/rake"
  queue "sudo ln -s /opt/local/ruby/current/sbin/rdoc    /opt/local/sbin/rdoc"
  queue "sudo ln -s /opt/local/ruby/current/sbin/ri      /opt/local/sbin/ri"
  queue "sudo ln -s /opt/local/ruby/current/sbin/ruby    /opt/local/sbin/ruby"
  queue "sudo ln -s /opt/local/ruby/current/sbin/testrb  /opt/local/sbin/testrb"

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

desc "Instalar Nginx"
namespace :nginx do
  task :install do
    print_str "-----> Instalar nginx"
    queue "sudo apt-get install libpcre3-dev libssl-dev -y"
    queue "sudo wget http://nginx.org/download/nginx-1.4.1.tar.gz"
    queue "sudo tar xvf nginx-1.4.1.tar.gz"
    queue "cd nginx-1.4.1"
    queue "sudo ./configure --prefix=/opt/local/nginx/1.4.1  --with-http_ssl_module --with-http_realip_module  --with-http_gzip_static_module --conf-path=/etc/nginx/nginx.conf  --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --http-log-path=/var/log/nginx/access.log  --http-client-body-temp-path=/var/lib/nginx/body  --http-proxy-temp-path=/var/lib/nginx/proxy  --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --with-debug --with-ipv6"

    queue "sudo make && sudo make install"

    queue "sudo ln -s /opt/local/nginx/1.4.1 /opt/local/nginx/current"

    print_str "-----> Criando links simbolicos para a pasta bin e sbin"
    queue "sudo ln -s /opt/local/nginx/current/bin/nginx /opt/local/bin/nginx"
    queue "sudo ln -s /opt/local/nginx/current/sbin/nginx /opt/local/sbin/nginx"

    print_str "-----> Nginx version"
    queue "nginx -v"
  end

  task :conf do
    print_str "-----> Configurando nginx"
    queue "sudo mkdir /var/www"
    queue "sudo chown ubuntu:ubuntu /var/www"
    queue "sudo chmod 774 /var/www"

    queue "sudo mkdir -p /var/lib/nginx/body"
    queue "sudo mkdir -p /var/lib/nginx/proxy"
    queue "sudo mkdir -p /var/lib/nginx/fastcgi"
    queue "sudo chown -R ubuntu:ubuntu /var/lib/nginx"
    queue "sudo mkdir -p /var/log/nginx/"
    queue "sudo chown ubuntu:ubuntu /var/log/nginx"
    queue "sudo mkdir /etc/nginx/ssl"
    queue "sudo mkdir /etc/nginx/sites-enabled"
  end
end



