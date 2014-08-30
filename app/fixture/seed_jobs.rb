require 'mongoid'
require './app/models/job'
require './app/services/database'

def run!
  Database.load_config

  num_jobs_to_create = 2
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
  job.status = "Pending"
  job.save!
end

run! if __FILE__==$0