require 'pry'


class Computer

	def initialize(instructionSet, rom, debug = false)
		@debug = debug
		@clock = Clock.new
		@dataBus = Bus.new(8, @clock)
		@addressBus = Bus.new(16, @clock)
		@controlset = ControlSet.new
		@counter = Counter.new(@clock)
		@registers = {}
		@instructionSet = instructionSet
		initializeRegisters
		@memory = Memory.new(@clock, @addressBus, @dataBus, @controlset.controlLines[:readMemory], @controlset.controlLines[:writeMemory], @registers, rom)
		cl(:halt).onHigh do 
			@clock.halt
		end
		cl(:next).onHigh do
			@clock.onTickHigh do 
				@counter.reset
			end
		end
		@alu = ALU.new(@dataBus, @registers[:a], @registers[:b], @registers[:flags], cl(:aluCarry), cl(:aluInvert), cl(:aluZero), cl(:aluFunc0), cl(:aluFunc1), cl(:aluFunc2), cl(:aluEnable))
		reset
	end

	def reset
		@controlset.reset
		@clock.reset
		@registers[:pc].value = 0xC000
		@clock.tick
		@counter.reset
	end

	def run
		loop do
			dump_state if @debug
			step = microcode[@counter.value]
			puts "Step #{@counter.value}: [#{step.join(", ")}]\n" if @debug
			step = [:next] if step.empty?
			@controlset.set(step)
			break if !@clock.tick
		end
	end

	private

	def instruction
		code = @registers[:instruction].value
		decoded = @instructionSet.decode(code)
		puts "Instruction #{code}: #{decoded.name}\n" if @debug
		decoded
	end

	def microcode
		instruction.microcode(@registers[:flags].value)
	end

	def initializeRegisters
		{
			a: [:readA, :writeA],
			b: [:readB, :writeB],
			t: [:readT, :writeT],
			segment: [:readSegment, :writeSegment],
			flags: [:readFlags, :writeFlags],
			instruction: [:readInstruction, :writeInstruction],
		}.each do |sym, ops|
			@registers[sym] = Register.new(@dataBus, cl(ops[0]), cl(ops[1]))
		end
		{
			pc: [:readProgramCounter, :writeProgramCounter],
			sc: [:readStackCounter, :writeStackCounter],
			m: [:readM, :writeM],
			tm: [:readTM, :notConnected],
		}.each do |sym, ops|
			@registers[sym] = Register.new(@addressBus, cl(ops[0]), cl(ops[1]))
		end
		{
			m1: [:m, false, :readM1, :writeM1],
			m2: [:m, true, :readM2, :writeM2],
			pc1: [:pc, false, :readPC1, :writePC1],
			pc2: [:pc, true, :readPC2, :writePC2],
			tm1: [:tm, false, :notConnected, :writeTM1],
			tm2: [:tm, true, :notConnected, :writeTM2],
		}.each do |sym, ops|
			@registers[sym] = HalfRegister.new(@registers[ops[0]], ops[1], @dataBus, cl(ops[2]), cl(ops[3]))
		end
		@registers[:inc] = IncrementRegister.new(@addressBus, cl(:readAddressIncrement), cl(:writeAddressIncrement))
	end


	def dump_state
		puts "Registers: "
		@registers.each do |sym, register|
			if sym == :m || sym == :pc || sym == :inc || sym == :tm || sym == :sc
				puts "    #{sym}: #{"%04x" % register.value}" 
			else
				puts "    #{sym}: #{"%02x" % register.value}" 
			end
		end
		puts "Memory: "
		@memory.dump_state
	end

	def cl(symbol)
		@controlset.controlLines[symbol]
	end
end