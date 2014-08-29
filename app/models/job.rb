require 'mongoid'

class Job
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: String
  field :message, type: String
  field :worker, type: String
  field :start, type: Time
  field :stop, type: Time

  def self.get_next_job_to_process
    job = Job.where(:status => 'Pending').order_by([:created_at, :asc]).first

    unless job.nil?
      job.start = Job.utc_now
      job.worker = "worker #{Process.pid}"
      job.status = "Processing"
      job.save!
      job
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
