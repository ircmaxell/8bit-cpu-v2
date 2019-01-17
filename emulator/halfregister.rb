require 'pry'

class HalfRegister

	def initialize(parent, isLow, bus, readControl, writeControl)
		@parent = parent
		@isLow = isLow
		@bus = bus
		readControl.onHigh do 
			@bus.write do 
				read
			end
		end
		readControl.onLow do 
			@bus.endWrite
		end
		writeControl.onHigh do 
			@bus.read do |v|
				write(v)
			end
		end
	end

	def value
		read
	end

	def value=(value)
		write(value)
	end

	def read
		if @isLow
			@parent.value & 0xFF
		else
			(@parent.value >> 8) & 0xFF
		end
	end

	def write(value)
		if @isLow
			@parent.value = (@parent.value & 0xFF00) | (value & 0xFF)
		else
			@parent.value = ((value << 8) & 0xFF00) | (@parent.value & 0xFF)
		end
	end

end