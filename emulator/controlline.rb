

class ControlLine

	def initialize
		@value = false
		@queue = {
			onHigh: [],
			onLow: [],
			onChange: [],
		}
	end

	def onChange(&block)
		@queue[:onChange].push(block)
	end

	def onHigh(&block)
		@queue[:onHigh].push(block)
	end

	def onLow(&block)
		@queue[:onLow].push(block)
	end

	def value=(value)
		return if @value == value
		@value = value
		run @queue[:onHigh] if value == true
		run @queue[:onLow] if value == false
		runArg @queue[:onChange], value
	end

	private
	def run(blocks)
		blocks.each do |block|
			block.call
		end
	end

	def runArg(blocks, arg)
		blocks.each do |block|
			block.call(arg)
		end
	end

end