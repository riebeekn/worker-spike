require 'mongoid'

class Job
  include Mongoid::Document
  include Mongoid::Timestamps
  field :finished, type: Boolean
  field :failed, type: Boolean
  field :message, type: String
  field :engine_worker, type: String
  field :drive_train_worker, type: String
  field :body_worker, type: String
  field :assembly_worker, type: String
  field :start, type: Time
  field :stop, type: Time

  def self.get_next_job_to_process
    job = Job.where(:finished => false).order_by([:created_at, :asc]).first
    # job = Job.or(
    #   {engine_worker: nil}, 
    #   {drive_train_worker: nil},
    #   {body_worker: nil},
    #   {assembly_worker: nil}).
    #   order_by([:created_at, :asc]).first

      # this wrong will be updated for each stage of the job
    # unless job.nil?
    #   job.start = Job.utc_now
    #   job.save!
    #   job
    # end
  end

  def stop_processing_due_to_error(message = nil)
    self.failed = true
    self.stop = Job.utc_now
    self.message = message unless message.nil?
    self.save!
  end

  def finish_processing
    self.finished = true
    self.stop = Job.utc_now
    self.save!
  end

  private

    def self.utc_now
      Time.now.utc.strftime('%Y-%m-%d %H:%M:%S %Z')
    end
end
