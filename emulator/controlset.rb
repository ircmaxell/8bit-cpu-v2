

class ControlSet

	def initialize
		@controlLines = {}
		[
			:next,
			:halt,
			:readA,
			:writeA,
			:readB,
			:writeB,
			:readM,
			:writeM,
			:readM1,
			:writeM1,
			:readM2,
			:writeM2,
			:readPC1,
			:writePC1,
			:readPC2,
			:writePC2,
			:readT,
			:writeT,
			:readTM,
			:writeTM1,
			:writeTM2,
			:read0,
			:read1,
			:read0xC000,
			:readFlags,
			:writeFlags,
			:readMemory,
			:writeMemory,
			:readProgramCounter,
			:writeProgramCounter,
			:readStackCounter,
			:writeStackCounter,
			:readInstruction,
			:writeInstruction,
			:readAddressIncrement,
			:writeAddressIncrement,
			:readSegment,
			:writeSegment,
			:aluEnable,
			:aluCarry,
			:aluInvert,
			:aluZero,
			:aluFunc0,
			:aluFunc1,
			:aluFunc2,
			:notConnected,
		].each do |symbol|
			@controlLines[symbol] = ControlLine.new
		end

	end

	def controlLines
		@controlLines
	end

	def set(symbols)
		reset
		symbols.each do |sym|
			@controlLines[sym].value = true
		end
	end

	def reset
		@controlLines.each do |sym, line|
			line.value = false
		end
	end

end
