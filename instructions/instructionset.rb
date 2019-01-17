
class InstructionSet

	def initialize
		@instructions = {
			noop: NoOp.new,
			copy: Copy.new,
			copyi: CopyI.new,
			cmp: Cmp.new,
			halt: Halt.new,
		}
		[:add, :sub, :and, :or, :xor, :invert, :inc, :dec].each do |symbol|
			@instructions[symbol] = Alu.new(symbol)
		end
		[:jump, :jumpzero, :jumpnotzero, :jumpcarry, :jumpnotcarry, :jumpsign, :jumpnotsign, :jumpflag1, :jumpnotflag1].each do |symbol|
			@instructions[symbol] = Jump.new(symbol)
		end
	end

	def instruction(symbol)
		@instructions[symbol] || Halt.new
	end

	def compile(symbol, args = [])
		instruction(symbol).compile(args)
	end

	def instructions
		@instructions
	end

	def decode(code)
		instructions.each do |key, instruction|
			return instruction if instruction.code == code
		end
		return Halt.new
	end

end