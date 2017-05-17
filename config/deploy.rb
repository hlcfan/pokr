require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/puma'
# require 'mina/rvm'    # for rvm support. (http://rvm.io)
require 'mina/sitemap_generator'

set :domain, 'pokrex.com'
set :deploy_to, '/home/hlcfan/pokr'
set :app_path,  "#{fetch(:current_path)}"
set :repository, 'https://github.com/hlcfan/pokr.git'
set :branch, 'master'
set :user, 'hlcfan'
set :keep_releases, 5
set :term_mode, :system
set :rails_env, 'production'
set :force_asset_precompile, true

set :puma_socket, '/tmp/puma_pokr.sock'
set :puma_pid, 'tmp/pids/puma.pid'
set :puma_state, 'tmp/sockets/puma.state'

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
# set :shared_paths, ['config/database.yml', 'log', 'tmp/pids', 'tmp/sockets', 'public/system']
set :shared_dirs, fetch(:shared_dirs, []).push(*['log', 'tmp/pids', 'tmp/sockets', 'public/system', 'client/node_modules'])
set :shared_files, fetch(:shared_files, []).push(*['config/database.yml'])
# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-2.2.0@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  command %[mkdir -p "#{fetch(:shared_path)}/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/log"]

  command %[mkdir -p "#{fetch(:shared_path)}/uploads"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/uploads"]

  command %[mkdir -p "#{fetch(:shared_path)}/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/config"]

  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command  %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/database.yml'."]

  command %{
    mkdir -p "#{fetch(:deploy_to)}/shared/tmp/pids"
    mkdir -p "#{fetch(:deploy_to)}/shared/tmp/sockets"
  }
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
    invoke :'yarn:install'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'puma:phased_restart'
      invoke :'whenever:update'
      invoke :'sitemap:create'
    end
  end
end

desc "Seed data to the database"
task :seed => :environment do
  command "cd #{fetch(:current_path)}/"
  command "bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  command  %[echo "-----> Rake Seeding Completed."]
end

namespace :whenever do
  desc "Clear crontab"
  task :clear do
    command %{
      echo "-----> Clear crontab for #{fetch(:domain)}"
      #{echo_cmd %[cd #{fetch(:current_path)} ; bundle exec whenever --clear-crontab #{fetch(:domain)} --set 'environment=production&path=#{fetch(:current_path)}']}
    }
  end
  desc "Update crontab"
  task :update do
    command %{
      echo "-----> Update crontab for #{fetch(:domain)}"
      #{echo_cmd %[cd #{fetch(:current_path)} ; bundle exec whenever --update-crontab #{fetch(:domain)} --set 'environment=production&path=#{fetch(:current_path)}']}
    }
  end
  desc "Write crontab"
  task :write do
    command %{
      echo "-----> Update crontab for #{fetch(:domain)}"
      #{echo_cmd %[cd #{fetch(:current_path)} ; bundle exec whenever --write-crontab #{fetch(:domain)} --set 'environment=production&path=#{fetch(:current_path)}']}
    }
  end
end

namespace :yarn do
  desc "Yarn install"
  task :install do
    command %{
      echo "-----> Npm installing for #{fetch(:app_path)}"
    }
    command "cd #{fetch(:app_path)}"
    command "yarn"
  end
end

namespace :god do
  desc "Start God"
  task :start => :environment do
    command 'echo "------> Start God"'
    command %{
      cd #{app_path}
      bundle exec god -c config/puma.god
    }
  end

  desc "Stop God"
  task :stop do
    command 'echo "------> Stop God"'
    command %{
      cd #{app_path}
      bundle exec god stop puma
    }
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers