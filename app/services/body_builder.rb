require './app/services/logging'

class BodyBuilder
	def self.build(job)
		# job.num_times_body_processed++
		# job.save!

		Logging.info "building body..."
		sleep(4)
		
	end
end