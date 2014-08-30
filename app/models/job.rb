require 'mongoid'

class Job
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: String
  field :message, type: String
  field :engine_worker, type: String
  field :engine_status, type: String
  field :drive_train_worker, type: String
  field :drive_train_status, type: String
  field :body_worker, type: String
  field :body_status, type: String
  field :assembly_worker, type: String
  field :assembly_status, type: String
  field :start, type: Time
  field :stop, type: Time

  def self.get_next_job_to_process
    job = Job.where(:engine_status => 'Done', 
                    :drive_train_status => 'Done',
                    :body_status => 'Done',
                    :assembly_status.ne => 'Done',
                    :assembly_worker => '').
            order_by([:created_at, :asc]).
            find_and_modify(
            {
              "$set" => {
                assembly_worker: "worker #{Process.pid}",
                assembly_status: "Starting"
              }
            })

    if !job.nil?
      job.reload
      return job
    end

    if job.nil?
      # job = Job.where(:status.ne => 'Assigning Worker').or({engine_status: 'Pending'}, 
      job = Job.or({:engine_status => 'Pending'},
                  {:drive_train_status => 'Pending'}, 
                  {:body_status => 'Pending'}).
            order_by([:created_at, :asc]).
            find_and_modify(
            {
              "$set" => {
                status: 'Assigning Worker'
              }
            })
    else
      return job
    end

    unless job.nil?
      if job.engine_worker == ''
        job.start = Job.utc_now
        job.engine_worker = "worker #{Process.pid}"
        job.engine_status = "Starting"
        job.status = "Processing"
        job.save!
        return job
      elsif job.drive_train_worker == ''
        job.drive_train_worker = "worker #{Process.pid}"
        job.drive_train_status = "Starting"
        job.status = "Processing"
        job.save!
        return job
      elsif job.body_worker == ''
        job.body_worker = "worker #{Process.pid}"
        job.body_status = "Starting"
        job.status = "Processing"
        job.save!
        return job
      end
    end

    if (job.nil?)
      return nil
    end
  end

    def stop_processing_due_to_error(message = nil)
    self.status = "Failed"
    self.stop = Job.utc_now
    self.message = message unless message.nil?
    self.save!
  end

  def finish_processing
    self.status = "Done"
    self.stop = Job.utc_now
    self.save!
  end

  private

    def self.utc_now
      Time.now.utc.strftime('%Y-%m-%d %H:%M:%S %Z')
    end
end
