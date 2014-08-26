require './app/services/database'
require './app/worker/controller'

def run!
  # set-up
  Database.load_config

  # loop infinite
  stop = false
  Signal.trap('INT') { stop = true }
  until stop
    job_found = Controller.process_next

    # keep looking for more jobs if a job was just processed
    # otherwise sleep for a bit
    pause_loop unless job_found
    # stop = true # kill after a single loop
  end
end

def pause_loop
  print "."
  if ENV['WORKER_SLEEP_SECONDS']
    sleep(ENV['WORKER_SLEEP_SECONDS'].to_i)
  else
    sleep(10)
  end
end

run! if __FILE__==$0
