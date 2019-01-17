

class Clock

	def initialize
		reset
		@persistantQueue = {
			beforeTickHigh: [],
			afterTickHigh: [],
			beforeTickLow: [],
			afterTickLow: [],
		}
	end

	def halt
		@halted = true
		@midtick = false
	end

	def reset
		@halted = false
		@midtick = false
		clear
	end

	def clear 
		@queue = {
			onTickHigh: [],
			onTickLow: [],
		}
		@midtick = false
	end

	def tick
		return false if @halted
		@midtick = true
		run @persistantQueue[:beforeTickHigh]
		run @queue[:onTickHigh]
		run @persistantQueue[:afterTickHigh]
		run @persistantQueue[:beforeTickLow]
		run @queue[:onTickLow]
		run @persistantQueue[:afterTickLow]
		clear
		sleep 0.5
		true
	end

	def midtick?
		@midtick
	end

	def onTickHigh(&block)
		@queue[:onTickHigh].push(block)
	end

	def afterTickHigh(&block)
		@persistantQueue[:afterTickHigh].push(block)
	end

	def afterTickLow(&block)
		@persistantQueue[:afterTickLow].push(block)
	end

	def beforeTickHigh(&block)
		@persistantQueue[:beforeTickHigh].push(block)
	end

	def beforeTickLow(&block)
		@persistantQueue[:beforeTickLow].push(block)
	end

	def onTickLow(&block)
		@queue[:onTickLow].push(block)
	end

	private

	def run(blocks)
		blocks.each do |block|
			block.call
		end
	end

end





