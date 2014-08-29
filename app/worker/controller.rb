require './app/models/job'
require './app/services/assembler'
require './app/services/body_builder'
require './app/services/drive_train_builder'
require './app/services/engine_builder'
require './app/services/logging'

class Controller

  def self.process_next
    job = Job.get_next_job_to_process 

    unless job.nil?
      begin
        process(job)
      rescue => e
        job.stop_processing_due_to_error(e.message)
        Logging.error(e.message)
        Logging.error(e.backtrace)
      end
    end

    !job.nil?
  end

  private 
  	def self.process(job)
      Logging.info "Processing job #{job._id}"

      EngineBuilder.build(job)
      DriveTrainBuilder.build(job)
      BodyBuilder.build(job)
      Assembler.assemble(job)
      job.finish_processing
    end
end