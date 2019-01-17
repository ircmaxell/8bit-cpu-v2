
class Counter

	def initialize(clock)
		@value = 0
		@skipnext = false
		@clock = clock
		@clock.afterTickLow do 
			@value = (@value + 1) % 0x0F if !@skipnext
			@skipnext = false
		end
	end

	def reset
		@value = 0
		@skipnext = @clock.midtick?
	end

	def value
		@value
	end
end