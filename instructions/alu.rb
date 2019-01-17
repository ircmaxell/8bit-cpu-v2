
class Alu < Instruction

	def initialize(symbol)
		super()
		ops = {
			add: [0x10, []],
			sub: [0x11, [:aluInvert, :aluCarry]],
			and: [0x12, [:aluFunc0]],
			or: [0x13, [:aluFunc1]],
			xor: [0x14, [:aluFunc0, :aluFunc1]],
			invert: [0x15, [:aluZero, :aluInvert, :aluFunc0, :aluFunc1]],
			inc: [0x16, [:aluZero, :aluCarry]],
			dec: [0x17, [:aluZero, :aluInvert]],
		}[symbol]
		@name = symbol.to_s
		@code = ops[0]
		@aluOps = ops[1]
	end

	def name
		@name
	end

	def compile(args = [])
		raise "Memory Addresses required" if args.length != 1
		[	@code,
			(args[0] >> 8) & 0xFF, 
			args[0] & 0xFF,
		]
	end

	def instruction_microcode(flags)
		[
			[:readProgramCounter, :readMemory, :writeTM1, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
			[:readProgramCounter, :readMemory, :writeTM2, :writeAddressIncrement],
			[:readAddressIncrement, :writeProgramCounter],
			[@aluOps, :aluEnable, :readTM, :writeMemory].flatten.compact,
		]
	end

end