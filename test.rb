Dir["./emulator/*.rb"].each {|file| require file }
Dir["./instructions/*.rb"].each {|file| require file }

i = InstructionSet.new



computer = Computer.new(i, [
	i.compile(:add, [0x0000]),
	i.compile(:cmp),
	i.compile(:jumpzero, [0xC00A]),
	i.compile(:jump, [0xC000]),
	i.compile(:halt),
].flatten, true)

computer.run
