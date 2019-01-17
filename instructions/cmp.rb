
class Cmp < Instruction

	def initialize
		super
		@code = 0x1F
	end

	def instruction_microcode(flags)
		[
			[:aluInvert, :aluCarry, :aluEnable],
		]
	end

end