PROJECT_ROOT = File.expand_path("../..", Dir.pwd)
RAILS_ROOT = File.join(PROJECT_ROOT, "current")

God.watch do |w|
  pid_file = File.join(RAILS_ROOT, "tmp/puma.pid")

  w.name = "puma"
  w.interval = 60.seconds
  w.start = "cd #{RAILS_ROOT} && RAILS_ENV=production bundle exec puma -C config/puma.rb"
  w.stop = "cd #{RAILS_ROOT} && bundle exec pumactl -P tmp/puma.pid stop"
  w.restart = "cd #{RAILS_ROOT} && bundle exec pumactl -P tmp/puma.pid restart"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file = pid_file

  w.behavior(:clean_pid_file)

  # When to start?
  w.start_if do |start|
    start.condition(:process_running) do |c|
      # We want to check if deamon is running every 5 seconds
      # and start it if isn't running
      c.interval = 5.seconds
      c.running = false
    end
  end
end