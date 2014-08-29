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
  job.status = "Pending"
  job.save!
end

run! if __FILE__==$0