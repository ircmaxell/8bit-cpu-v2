
class Copy < Instruction

	def initialize
		super
		@code = 0x02
	end

	def compile(args = [])
		raise "Two Memory Addresses required" if args.length != 2
		[	@code,
			(args[0] >> 8) & 0xFF, 
			args[0] & 0xFF,
			(args[1] >> 8) & 0xFF, 
			args[1] & 0xFF,
		]
	end

	def instruction_microcode(flags)
		[
			[:readProgramCounter, :readMemory, :writeTM1, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
			[:readProgramCounter, :readMemory, :writeTM2, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
			[:readTM, :readMemory, :writeT],
			[:readProgramCounter, :readMemory, :writeTM1, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
			[:readProgramCounter, :readMemory, :writeTM2, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
			[:readT, :readTM, :writeMemory],
		]
	end

end