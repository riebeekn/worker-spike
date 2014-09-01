require './app/services/logging'

class Assembler
	def self.assemble(job)
		Logging.info "\t\tassembling..."
		sleep(7)
		job.update_assembly
	end
end