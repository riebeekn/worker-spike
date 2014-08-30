require 'mongoid'
require './app/models/job'
require './app/services/database'

def run!
  Database.load_config

  num_jobs_to_create = 20
  Job.collection.drop
  for i in 1..num_jobs_to_create
    create_job
    if (i < num_jobs_to_create)
      sleep(5)
    end
  end

end

def create_job
  job = Job.new
  job.status = 'Pending'

  job.engine_worker = ''
  job.engine_status = 'Pending'
  
  job.drive_train_worker = ''
  job.drive_train_status = 'Pending'
  
  job.body_worker = ''
  job.body_status = 'Pending'
  
  job.assembly_worker = ''
  job.assembly_status = 'Pending'
  
  job.save!
end

run! if __FILE__==$0
