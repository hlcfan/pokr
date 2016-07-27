RAILS_ROOT = File.dirname(File.dirname(__FILE__))

God.watch do |w|
  pid_file = File.join(RAILS_ROOT, "tmp/pids/puma.pid")

  w.name = "thin"
  w.interval = 60.seconds
  w.start = "cd #{RAILS_ROOT} && bundle exec puma -C config/puma.rb"
  w.stop = "cd #{RAILS_ROOT} && bundle exec puma stop -C config/puma.rb"
  w.restart = "#{RAILS_ROOT} && bundle exec puma restart -C config/puma.rb"
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