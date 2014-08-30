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
        job.engine_status = "Processing"
        job.save!
        EngineBuilder.build(job)
        job.engine_status = "Done"
        job.save!
      elsif (job.drive_train_status == "Starting")
        job.drive_train_status = "Processing"
        job.save!
        DriveTrainBuilder.build(job)
        job.drive_train_status = "Done"
        job.save!
      elsif (job.body_status == "Starting")
        job.body_status = "Processing"
        job.save!
        BodyBuilder.build(job)
        job.body_status = "Done"
        job.save!
      elsif (job.assembly_status == "Starting")
        job.assembly_status = "Processing"
        job.save!
        Assembler.assemble(job)
        job.assembly_status = "Done"
        job.status = "Done"
        job.save!
      end
    end
end