require './app/services/logging'

class EngineBuilder
	def self.build(job)
		Logging.info "building engine..."
		sleep(5)
	end
end