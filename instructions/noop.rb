
class NoOp < Instruction

	def initialize
		super
		@code = 0x00
	end

	def instruction_microcode(flags)
		[
		]
	end

end