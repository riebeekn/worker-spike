require 'mongoid'

class Job
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: String
  field :message, type: String
  field :engine_worker, type: String
  field :engine_status, type: String
  field :num_eng, type: Integer
  field :drive_train_worker, type: String
  field :drive_train_status, type: String
  field :num_dt, type: Integer
  field :body_worker, type: String
  field :body_status, type: String
  field :num_body, type: Integer
  field :assembly_worker, type: String
  field :assembly_status, type: String
  field :num_assembly, type: Integer
  field :start, type: Time
  field :stop, type: Time

  def update_engine
    self.inc(num_eng: 1)
  end

  def update_dt
    self.inc(num_dt: 1)
  end

  def update_body
    self.inc(num_body: 1)
  end

  def update_assembly
    self.inc(num_assembly: 1)
  end

  def self.get_next_job_to_process
    # first check for any jobs ready to be assembled
    job = get_next_job_to_assemble
    if !job.nil?
      job.reload
      return job
    end

    # if no jobs to assemble check for next job to process
    job = get_next_job
    if job.nil?
      return nil
    else 
      update_and_return_job(job)
    end
  end

  def stop_processing_due_to_error(message = nil)
    if (message.nil?)
      msg = ''
    else
      msg = message
    end
    self.set(
      status: "Failed",
      stop: Job.utc_now,
      message: msg
    )
  end

  def finish_processing
    self.set(
      status: "Done",
      stop: Job.utc_now
    )
  end

  private
    def self.get_next_job_to_assemble
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
    end

    def self.get_next_job
      Job.where(:status.ne => 'Assigning Worker').or({:engine_status => 'Pending'},
                  {:drive_train_status => 'Pending'}, 
                  {:body_status => 'Pending'}).
            order_by([:created_at, :asc]).
            find_and_modify(
            {
              "$set" => {
                status: 'Assigning Worker'
              }
            })
      
    end

    def self.update_and_return_job(job)
      if job.engine_worker == ''
        job.set(
          start: Job.utc_now, 
          engine_worker: "worker #{Process.pid}", 
          engine_status: "Starting", 
          status: "Processing"
        )
      elsif job.drive_train_worker == ''
        job.set(
          drive_train_worker: "worker #{Process.pid}",
          drive_train_status: "Starting",
          status: "Processing"
        )
      elsif job.body_worker == ''
        job.set(
          body_worker: "worker #{Process.pid}",
          body_status: "Starting",
          status: "Processing"
        )
      end

      return job
    end

    def self.utc_now
      Time.now.utc.strftime('%Y-%m-%d %H:%M:%S %Z')
    end
end

