# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum, this matches the default thread size of Active Record.
#
rails_env = "production"

if rails_env == ENV["RAILS_ENV"]
  app_root = File.dirname(File.dirname(__FILE__))

  pidfile "tmp/pids/puma.pid"
  state_path "tmp/sockets/puma.state"
  bind 'unix:/tmp/puma_pokr.sock'
  daemonize true
  # workers 1
  threads 0, 16
  prune_bundler

  # Specifies the `environment` that Puma will run in.
  #
  environment ENV.fetch("RAILS_ENV") { rails_env }

  on_worker_boot do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.establish_connection
    end
  end

  before_fork do
    ActiveRecord::Base.connection_pool.disconnect!
  end

  # Specifies the number of `workers` to boot in clustered mode.
  # Workers are forked webserver processes. If using threads and workers together
  # the concurrency of the application would be max `threads` * `workers`.
  # Workers do not work on JRuby or Windows (both of which do not support
  # processes).
  #
  # workers ENV.fetch("WEB_CONCURRENCY") { 2 }

  # Use the `preload_app!` method when specifying a `workers` number.
  # This directive tells Puma to first boot the application and load code
  # before forking the application. This takes advantage of Copy On Write
  # process behavior so workers use less memory. If you use this option
  # you need to make sure to reconnect any threads in the `on_worker_boot`
  # block.
  #
  # preload_app!

  # The code in the `on_worker_boot` will be called if you are using
  # clustered mode by specifying a number of `workers`. After each worker
  # process is booted this block will be run, if you are using `preload_app!`
  # option you will want to use this block to reconnect to any threads
  # or connections that may have been created at application boot, Ruby
  # cannot share connections between processes.
  #
  # on_worker_boot do
  #   ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  # end

  # Allow puma to be restarted by `rails restart` command.
  plugin :tmp_restart

end