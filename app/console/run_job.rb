require './app/services/database'
require './app/worker/controller'

def run!
  # set-up
  Database.load_config

  Controller.process_next
end

run! if __FILE__==$0
