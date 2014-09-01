require './app/services/logging'

class DriveTrainBuilder
	def self.build(job)
		Logging.info "\t\tbuilding drive train..."
		sleep(3)
		job.update_dt
	end
end