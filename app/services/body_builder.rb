require './app/services/logging'

class BodyBuilder
	def self.build(job)
		Logging.info "\t\tbuilding body..."
		sleep(4)
	end
end