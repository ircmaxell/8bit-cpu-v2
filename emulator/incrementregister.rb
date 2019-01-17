

class IncrementRegister

	def initialize(bus, readControl, writeControl)
		@bus = bus
		@value = 0
		readControl.onHigh do 
			@bus.write do 
				@value
			end
		end
		readControl.onLow do 
			@bus.endWrite
		end
		writeControl.onHigh do 
			@bus.read do |value|
				@value = value + 1
			end
		end
	end

	def value
		@value
	end

	def value=(value)
		@value = value
	end

end