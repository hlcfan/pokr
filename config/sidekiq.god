PROJECT_ROOT = File.expand_path("../..", Dir.pwd)
RAILS_ROOT = File.join(PROJECT_ROOT, "current")

God.watch do |w|
  pid_file = File.join(RAILS_ROOT, "tmp/pids/sidekiq.pid")

  w.name = "sidekiq"
  w.interval = 60.seconds
  w.start = "cd #{RAILS_ROOT} && RAILS_ENV=production bundle exec sidekiq -C config/sidekiq.yml"
  w.stop = "cd #{RAILS_ROOT} && bundle exec sidekiqctl stop -P tmp/pids/sidekiq.pid"
  w.restart = "cd #{RAILS_ROOT} && bundle exec sidekiqctl restart -P tmp/pids/sidekiq.pid"
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
