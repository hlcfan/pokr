require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

set :domain, '10.119.35.138'
set :deploy_to, '/var/www/poker'
set :app_path,  "#{deploy_to}/#{current_path}"
set :repository, 'https://github.com/hlcfan/pokr.git'
set :branch, 'master'
set :user, 'active'
set :keep_releases, 5
set :term_mode, :system
set :rails_env, 'production'

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.2.1@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/uploads"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]

  queue! %{
    mkdir -p "#{deploy_to}/shared/tmp/pids"
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
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'thin:start'
    end
  end
end

desc "Seed data to the database"
task :seed => :environment do
    queue "cd #{deploy_to}/#{current_path}/"
    queue "bundle exec rake db:seed RAILS_ENV=#{rails_env}"
    queue  %[echo "-----> Rake Seeding Completed."]
end

#                                                                       Unicorn
# ==============================================================================
namespace :thin do
  set :thin_pid, "tmp/pids/thin.pid"
  set :start_thin, %{
    cd #{app_path}
    bundle exec thin restart -C config/thin.yml
  }

#                                                                    Start task
# ------------------------------------------------------------------------------
  desc "Start thin"
  task :start => :environment do
    queue 'echo "-----> Start Thin"'
    queue! start_thin
  end

#                                                                     Stop task
# ------------------------------------------------------------------------------
  desc "Stop thin"
  task :stop do
    queue 'echo "-----> Stop Thin"'
    queue! %{
      test -s "#{thin_pid}" && kill -QUIT `cat "#{thin_pid}"` && echo "Stop Ok" && exit 0
      echo >&2 "Not running"
    }
  end

#                                                                  Restart task
# ------------------------------------------------------------------------------
  desc "Restart thin using 'upgrade'"
  task :restart => :environment do
    invoke 'thin:stop'
    invoke 'thin:start'
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers