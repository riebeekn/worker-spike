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
      # Logging.info "\tStatus: #{job.status}"
      # Logging.info "\tEngine status: #{job.engine_status}"
      # Logging.info "\tDT status: #{job.drive_train_status}"
      # Logging.info "\tBody status: #{job.body_status}"
      # Logging.info "\tAssembly status: #{job.assembly_status}"

      if (job.engine_status == "Starting")
        job.set(engine_status: "Processing")
        EngineBuilder.build(job)
        job.set(engine_status: "Done")
      elsif (job.drive_train_status == "Starting")
        job.set(drive_train_status: "Processing")
        DriveTrainBuilder.build(job)
        job.set(drive_train_status: "Done")
      elsif (job.body_status == "Starting")
        job.set(body_status: "Processing")
        BodyBuilder.build(job)
        job.set(body_status: "Done")
      elsif (job.assembly_status == "Starting")
        job.set(assembly_status: "Processing")
        Assembler.assemble(job)
        job.set(assembly_status: "Done")
        job.finish_processing
      end
    end
end