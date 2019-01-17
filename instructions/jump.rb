
class Jump < Instruction

	def initialize(symbol)
		super()
		ops = {
			jump:         [0x30, 0b0000],
			jumpzero:     [0x31, 0b0001],
			jumpnotzero:  [0x32, 0b0001, 0b000],
			jumpsign:     [0x33, 0b0010],
			jumpnotsign:  [0x34, 0b0010, 0],
			jumpcarry:    [0x35, 0b0100],
			jumpnotcarry: [0x36, 0b0100, 0],
			jumpflag1:     [0x37, 0b00010000],
			jumpnotflag1:  [0x38, 0b00010000, 0],
		}[symbol]
		@name = symbol
		@code = ops[0]
		@mask = @maskResult = ops[1]
		@maskResult = ops[2] if ops.length > 2
	end

	def name
		@name
	end

	def compile(args = [])
		raise "Address argument required" if args.length != 1
		[@code, (args[0] >> 8) & 0xFF, args[0] & 0xFF]
	end

	def instruction_microcode(flags)
		result = [
			[:readProgramCounter, :readMemory, :writeTM1, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
			[:readProgramCounter, :readMemory, :writeTM2, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
		]
		if @maskResult == (flags & @mask)
			result.push([:readTM, :writeProgramCounter])
		end
		result
	end

end