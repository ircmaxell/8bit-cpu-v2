
class CopyI < Instruction

	def initialize
		super
		@code = 0x03
	end

	def compile(args = [])
		raise "Value and Address required" if args.length != 2
		[	@code,
			args[0] & 0xFF,
			(args[1] >> 8) & 0xFF, 
			args[1] & 0xFF,
		]
	end

	def instruction_microcode(flags)
		[
			[:readProgramCounter, :readMemory, :writeT, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
			[:readProgramCounter, :readMemory, :writeTM1, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
			[:readProgramCounter, :readMemory, :writeTM2, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
			[:readT, :readTM, :writeMemory],
		]
	end

end