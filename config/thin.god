RAILS_ROOT = File.dirname(File.dirname(__FILE__))

God.watch do |w|
  pid_file = File.join(RAILS_ROOT, "tmp/pids/thin.0.pid")

  w.name = "thin"
  w.interval = 60.seconds
  w.start = "bundle exec thin start -C config/thin.yml"
  w.stop = "kill -9 `ps -ef | grep thin | grep -v grep | awk '{print $2}'`"
  w.restart = "bundle exec thin restart -C config/thin.yml"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file = pid_file

  w.behavior(:clean_pid_file)

  # When to start?
  w.start_if do |start|
    start.condition(:process_running) do |c|
      # We want to check if deamon is running every ten seconds
      # and start it if itsn't running
      c.interval = 10.seconds
      c.running = false
    end
  end