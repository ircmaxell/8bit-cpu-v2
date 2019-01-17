
class Instruction

	def initialize
		@code = 0
	end

	def code
		@code
	end

	def compile(args = [])
		raise "Too many args" if args.length > 0
		@code
	end

	def name
		self.class.to_s
	end

	def microcode(flags)
		result = Array.new(16).fill { [] }
		result[0] = [:readProgramCounter, :readMemory, :writeInstruction, :writeAddressIncrement]
		result[1] = [:readAddressIncrement, :writeProgramCounter]
		idx = 2
		instruction_microcode(flags).each do |code|
			result[idx] = code
			idx = idx + 1
		end
		result
	end
	
	def instruction_microcode(flags)
		[]
	end
end