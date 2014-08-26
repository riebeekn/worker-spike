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

			job.engine_worker = "worker #{Process.pid}"
      EngineBuilder.build(job)
      job.engine_finished = true
      job.drive_train_worker = "worker #{Process.pid}"
      DriveTrainBuilder.build(job)
      job.drive_train_finished = true
      job.body_worker = "worker #{Process.pid}"
      BodyBuilder.build(job)
      job.body_finished = true
      job.assembly_worker = "worker #{Process.pid}"
      Assembler.assemble(job)
      job.assembly_finished = true
      job.finish_processing
    end

    # def self.process(job)
    #   Logging.info "Processing job #{job._id}"

    #   if (!job.engine_finished && job.engine_worker == nil)
    #     job.engine_worker = "worker #{Process.pid}"
    #     job.save!
    #     EngineBuilder.build(job)
    #     job.engine_finished = true
    #     job.save    
    #   elsif (!job.drive_train_finished && job.drive_train_worker == nil)
    #     job.drive_train_worker = "worker #{Process.pid}"
    #     job.save!
    #     DriveTrainBuilder.build(job)
    #     job.drive_train_finished = true
    #     job.save!
    #   elsif (!job.body_finished && job.body_worker == nil)
    #     job.body_worker = "worker #{Process.pid}"
    #     job.save!
    #     BodyBuilder.build(job)
    #     job.body_finished = true
    #     job.save!
    #   end

    #   if (job.body_finished && job.drive_train_finished && job.engine_finished &&
    #      !job.assembly_finished && job.assembly_worker == nil)
    #     job.assembly_worker = "worker #{Process.pid}"
    #     job.save!
    #     Assembler.assemble(job)
    #     job.assembly_finished = true
    #     job.save!
    #   end

    #   if (job.assembly_finished)
    #     job.finish_processing
    #   end
    # end
end