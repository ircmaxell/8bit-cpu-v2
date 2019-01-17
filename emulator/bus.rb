require 'pry'

class Bus

	def initialize(width, clock)
		@clock = clock
		@width = width
		@dirty = true
		@value = nil
	end

	def endWrite
		@dirty = true
		@value = nil
	end

	def write
		@clock.onTickHigh do

			store yield
		end
	end

	def read
		@clock.onTickLow do
			raise "Dirty Read" if @dirty
			yield(@value)
		end
	end

	def value
		@value
	end

	def value=(value)
		store value
	end

	private

	def bitmask
		(1 << @width) - 1
	end

	def store(value)
		raise "Double Write" if !@dirty
		@dirty = false
		@value = value & bitmask
	end

end