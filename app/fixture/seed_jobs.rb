require 'mongoid'
require './app/models/job'
require './app/services/database'

def run!
  Database.load_config

  Job.collection.drop
  for i in 1..2
    create_job
  end

end

def create_job
  job = Job.new
  job.finished = false
  job.engine_finished = false
  job.drive_train_finished = false
  job.body_finished = false
  job.assembly_finished = false
  job.save!
end

run! if __FILE__==$0