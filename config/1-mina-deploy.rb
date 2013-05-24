require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :app,                 'mirafloris'
set :domain,              '54.232.210.178'
set :identity_file,       File.join(ENV["HOME"], ".ec2", "mirafloris.pem") 
set :user,                'ubuntu'

set :deploy_to, "/var/www/#{app}"
set :repository, "https://github.com/candidosales/#{app}.git"
set :branch, 'master'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[-----> Be sure to edit 'shared/config/database.yml'.]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      queue 'touch tmp/restart.txt'
    end

    task :start do
      %w(config/database.yml).each do |path|
        from  = "#{deploy_to}/#{path}"
        to    = "#{current}/#{path}"

        run "if [ -f '#{to}' ]; then rm '#{to}'; fi; ln -s #{from} #{to}"
      end

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
end

namespace :rails do
  task :db_create do
    queue 'RAILS_ENV="production" bundle exec rake db:create'
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

