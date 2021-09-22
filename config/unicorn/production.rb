worker_processes ENV["UNICORN_PROC_NUM"].to_i.nonzero? || 8
preload_app true

current_path = File.expand_path("../..", __dir__)
working_directory current_path.to_s
pid "#{current_path}/tmp/pids/unicorn.pid"

listen 3000, tcp_nopush: true
logger Logger.new($stdout)

# use correct Gemfile on restarts
before_exec do |_server|
  ENV["BUNDLE_GEMFILE"] = "#{current_path}/api/Gemfile"
end

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    begin
      ActiveRecord::Base.connection.disconnect!
    rescue ActiveRecord::ConnectionNotEstablished
      nil
    end
  end

  # This allows a new master process to incrementally
  # phase out the old master process with SIGTTOU to avoid a
  # thundering herd (especially in the "preload_app false" case)
  # when doing a transparent upgrade.  The last worker spawned
  # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = ((worker.nr + 1) >= server.worker_processes) ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH # rubocop:disable Lint/SuppressedException
    end
  end

  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  sleep 1
end

after_fork do |_server, _worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
