

class ConstRegister

	def initialize(value, bus, readControl)
		@bus = bus
		@value = value
		readControl.onHigh do 
			@bus.write do 
				value
			end
		end
		readControl.onLow do 
			@bus.endWrite
		end
	end

	def value
		@value
	end

end