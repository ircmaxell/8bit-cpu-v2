
class Halt < Instruction

	def initialize
		super
		@code = 0x7F
	end

	def instruction_microcode(flags)
		[
			[:halt]
		]
	end

end