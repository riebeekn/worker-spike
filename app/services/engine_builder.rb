require './app/services/logging'

class EngineBuilder
	def self.build(job)
		Logging.info "\t\tbuilding engine..."
		sleep(5)
	end
end